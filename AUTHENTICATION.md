# Authentication Flow Documentation

## Overview

The AiChat app uses Firebase Authentication with three authentication methods:
1. **Anonymous Sign-In**: Automatic on first launch
2. **Apple Sign-In**: SSO provider option
3. **Google Sign-In**: SSO provider option

## Architecture

### Core Components

- **FirebaseAuthService**: Main authentication service (`AiChat/Services/Auth/FirebaseAuthService.swift`)
- **UserAuthInfo**: User data model with uid, email, isAnonymous flag
- **CreateAccountView**: Sign-in UI for Apple/Google SSO
- **SettingsView**: Account management (sign out, delete, upgrade anonymous)

### Environment Integration

FirebaseAuthService is injected into the environment:
```swift
@Environment(\.authService) private var authService
```

## Authentication Flows

### 1. Anonymous Sign-In (Automatic)

**When**: App launch, when no user is authenticated
**Where**: `AppView.checkUserStatus()`

**Flow**:
```
App Launch
    ↓
Check Auth.auth().currentUser
    ↓
If nil → signInAnonymously()
    ↓
Create anonymous Firebase user
    ↓
User can use app with temporary account
```

**Code**:
```swift
func signInAnonymously() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
    let result = try await Auth.auth().signInAnonymously()
    return result.asAuthInfo
}
```

**User State**:
- `isUserSignedIn: true`
- `isAnonymousUser: true`
- Settings shows: "Save & back-up Account" button

---

### 2. Apple Sign-In with Account Linking

**When**: User taps "Save & back-up Account" → selects Apple
**Where**: `FirebaseAuthService.signInApple()`

**Flow A: New Apple User (No existing account)**
```
User taps Apple Sign-In
    ↓
SignInWithAppleHelper gets Apple credential
    ↓
Create OAuthProvider credential
    ↓
Check: Is current user anonymous?
    ↓
YES → Link credential to anonymous account
    ↓
user.link(with: credential)
    ↓
Reload user to get fresh state
    ↓
Return UserAuthInfo with isAnonymous: false
```

**Flow B: Existing Apple Account (Credential already used)**
```
User taps Apple Sign-In
    ↓
SignInWithAppleHelper gets Apple credential
    ↓
Check: Is current user anonymous?
    ↓
YES → Attempt link: user.link(with: credential)
    ↓
FAILS with error code 17025 (credentialAlreadyInUse)
    ↓
Extract secondary credential from error.userInfo
    ↓
Sign in with secondary credential
    ↓
Return existing Apple account
    ↓
Anonymous account is discarded
```

**Flow C: Direct Sign-In (No anonymous account)**
```
User taps Apple Sign-In
    ↓
Check: Is current user anonymous?
    ↓
NO → Direct sign-in with credential
    ↓
Auth.auth().signIn(with: credential)
    ↓
Return UserAuthInfo
```

**Code**:
```swift
func signInApple() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
    let helper = SignInWithAppleHelper()
    let response = try await helper.signIn()
    let credential = OAuthProvider.credential(
        providerID: AuthProviderID.apple,
        idToken: response.token,
        rawNonce: response.nonce
    )

    // Attempt account linking if anonymous
    if let user = Auth.auth().currentUser, user.isAnonymous {
        do {
            let result = try await user.link(with: credential)
            try await result.user.reload() // Critical: Refresh to get isAnonymous: false
            let refreshedUser = Auth.auth().currentUser!
            return (UserAuthInfo(user: refreshedUser), result.additionalUserInfo?.isNewUser ?? false)
        } catch {
            let nsError = error as NSError
            if nsError.code == 17025 { // ERROR_CREDENTIAL_ALREADY_IN_USE
                if let secondaryCredential = nsError.userInfo["FIRAuthErrorUserInfoUpdatedCredentialKey"] as? AuthCredential {
                    let result = try await Auth.auth().signIn(with: secondaryCredential)
                    return result.asAuthInfo
                }
            }
            throw error
        }
    }

    // Direct sign-in
    let result = try await Auth.auth().signIn(with: credential)
    return result.asAuthInfo
}
```

**Critical Implementation Details**:

1. **User Reload After Linking**: Must call `user.reload()` after successful linking
   - Firebase caches user state
   - Without reload, `isAnonymous` remains `true` even after linking
   - This caused the bug where users stayed anonymous after SSO

2. **Secondary Credential Pattern**: For error code 17025
   - Error indicates credential belongs to existing account
   - Firebase provides secondary credential in `error.userInfo["FIRAuthErrorUserInfoUpdatedCredentialKey"]`
   - Sign in with this credential to access existing account
   - Anonymous account data is lost (intentional behavior)

**User State After Success**:
- `isUserSignedIn: true`
- `isAnonymousUser: false`
- Settings shows: "Sign Out" button

---

### 3. Google Sign-In with Account Linking

**When**: User taps "Save & back-up Account" → selects Google
**Where**: `FirebaseAuthService.signInGoogle()`

**Flow**: Identical to Apple Sign-In, but uses Google OAuth

**Setup Requirements**:
1. Enable Google Sign-In in Firebase Console
2. Download updated GoogleService-Info.plist with CLIENT_ID
3. Add URL scheme to Info.plist (reversed CLIENT_ID format)
4. Initialize GIDSignIn in AppDelegate:
   ```swift
   if let clientID = FirebaseApp.app()?.options.clientID {
       let config = GIDConfiguration(clientID: clientID)
       GIDSignIn.sharedInstance.configuration = config
   }
   ```
5. Handle OAuth callback in AppDelegate:
   ```swift
   func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
       return GIDSignIn.sharedInstance.handle(url)
   }
   ```

**Code**: Same structure as `signInApple()` but uses GoogleAuthProvider

**User State After Success**:
- `isUserSignedIn: true`
- `isAnonymousUser: false`
- Settings shows: "Sign Out" button

---

## User State Management

### Getting Current User

**Basic (Cached)**:
```swift
func getAuthenticatedUser() -> UserAuthInfo? {
    if let user = Auth.auth().currentUser {
        return UserAuthInfo(user: user)
    }
    return nil
}
```

**Refreshed (Latest from Firebase)**:
```swift
func getAuthenticatedUserRefreshed() async throws -> UserAuthInfo? {
    guard let user = Auth.auth().currentUser else { return nil }
    try await user.reload() // Fetch latest state
    guard let refreshedUser = Auth.auth().currentUser else { return nil }
    return UserAuthInfo(user: refreshedUser)
}
```

**When to Use Each**:
- Use `getAuthenticatedUser()` for quick checks (onboarding, navigation)
- Use `getAuthenticatedUserRefreshed()` in Settings to display accurate state
- Always refresh after authentication operations

### Settings View State

**State Variables**:
```swift
@State private var isUserSignedIn: Bool = false
@State private var isAnonymousUser: Bool = true
```

**Update Logic**:
```swift
func setAnonymousAccountStatus() async {
    do {
        let user = try await authService.getAuthenticatedUserRefreshed()
        isUserSignedIn = user != nil
        isAnonymousUser = user?.isAonymous == true
    } catch {
        let user = authService.getAuthenticatedUser()
        isUserSignedIn = user != nil
        isAnonymousUser = user?.isAonymous == true
    }
}
```

**UI Logic**:
```swift
if isUserSignedIn {
    if isAnonymousUser {
        // Show "Save & back-up Account" button
    } else {
        // Show "Sign Out" button
    }
} else {
    // Show "Sign In" button
}
```

---

## Sign Out Flow

**When**: User taps "Sign Out" in Settings
**Where**: `SettingsView.onSignoutPressed()`

**Flow**:
```
User taps Sign Out
    ↓
authService.signout()
    ↓
Auth.auth().signOut()
    ↓
Refresh UI state
    ↓
Navigate to onboarding
    ↓
Auto sign-in anonymously
```

**Code**:
```swift
func signout() throws {
    try Auth.auth().signOut()
}
```

---

## Delete Account Flow

**When**: User taps "Delete Account" in Settings
**Where**: `SettingsView.onDeleteAccountConfirmationPressed()`

**Flow**:
```
User taps Delete Account
    ↓
Show confirmation alert
    ↓
User confirms
    ↓
authService.deleteAccount()
    ↓
Auth.auth().currentUser.delete()
    ↓
Account removed from Firebase
    ↓
Navigate to onboarding
    ↓
Auto sign-in anonymously
```

**Code**:
```swift
func deleteAccount() async throws {
    guard let user = Auth.auth().currentUser else {
        throw AuthError.userNotFound
    }
    try await user.delete()
}
```

---

## Error Handling

### Common Error Codes

| Code | Name | Meaning | Handling |
|------|------|---------|----------|
| 17025 | ERROR_CREDENTIAL_ALREADY_IN_USE | Credential linked to existing account | Use secondary credential |
| 17026 | ERROR_PROVIDER_ALREADY_LINKED | Provider already linked to current user | Direct sign-in |
| 17004 | ERROR_USER_NOT_FOUND | User doesn't exist | Re-authenticate |
| 17999 | ERROR_INVALID_CREDENTIAL | Invalid auth credential | Retry authentication |

### Secondary Credential Pattern

When error code 17025 occurs:
1. Firebase provides the existing account's credential
2. Extract from `error.userInfo["FIRAuthErrorUserInfoUpdatedCredentialKey"]`
3. Sign in with this credential to access the existing account
4. Current anonymous session is discarded

**Why This Happens**:
- User previously signed in with Apple/Google
- Later signed out
- Reopened app (auto anonymous sign-in)
- Tried to link same Apple/Google account
- Firebase says "this email already has an account"
- Solution: Sign into that existing account instead

---

## Best Practices

### 1. Always Reload After Linking
```swift
let result = try await user.link(with: credential)
try await result.user.reload() // CRITICAL
let refreshedUser = Auth.auth().currentUser!
```

### 2. Use Refreshed State in Settings
```swift
let user = try await authService.getAuthenticatedUserRefreshed()
```

### 3. Handle Secondary Credentials
```swift
if nsError.code == 17025 {
    if let secondaryCredential = nsError.userInfo["FIRAuthErrorUserInfoUpdatedCredentialKey"] as? AuthCredential {
        let result = try await Auth.auth().signIn(with: secondaryCredential)
        return result.asAuthInfo
    }
}
```

### 4. Dismiss CreateAccountView After Success
```swift
.sheet(isPresented: $showCreateAccountView, onDismiss: {
    Task {
        await setAnonymousAccountStatus() // Refresh state
    }
})
```

---

## Testing Scenarios

### Scenario 1: First-Time User
1. Launch app → Anonymous sign-in
2. Settings → "Save & back-up Account"
3. Sign in with Apple → Account linked
4. Settings → "Sign Out" visible ✓

### Scenario 2: Returning User
1. Launch app → Anonymous sign-in
2. Settings → "Save & back-up Account"
3. Sign in with Apple (previously used)
4. Error 17025 → Secondary credential used
5. Signed into existing account ✓

### Scenario 3: Sign Out & Return
1. User signed in with Google
2. Settings → Sign Out
3. App navigates to onboarding
4. Auto sign-in anonymously
5. Settings → "Save & back-up Account" visible ✓

### Scenario 4: Account Deletion
1. User signed in (any method)
2. Settings → Delete Account → Confirm
3. Account deleted from Firebase
4. Auto sign-in anonymously
5. Fresh start ✓

---

## Security Considerations

1. **Anonymous Accounts**: Temporary, no email/password
   - Data tied to anonymous UID
   - Lost if not upgraded to permanent account
   - Cannot be recovered

2. **Account Linking**: Preserves data
   - Anonymous UID becomes permanent
   - All data migrated to permanent account
   - One-time operation (cannot unlink)

3. **Secondary Credentials**: User owns existing account
   - Firebase prevents duplicate accounts per email
   - Secondary credential ensures correct account access
   - Anonymous data is intentionally discarded

4. **Token Security**:
   - Apple: Uses nonce validation
   - Google: CLIENT_ID must match Firebase config
   - Tokens are short-lived and managed by Firebase

---

## Troubleshooting

### Issue: "Anonymous: true" after Apple/Google sign-in
**Cause**: Missing `user.reload()` after linking
**Fix**: Add reload after successful link operation

### Issue: "ERROR_CREDENTIAL_ALREADY_IN_USE" not handled
**Cause**: Secondary credential logic missing/broken
**Fix**: Check error code 17025 and extract secondary credential

### Issue: Settings shows wrong button
**Cause**: Using cached user state
**Fix**: Use `getAuthenticatedUserRefreshed()` in Settings

### Issue: Google Sign-In crashes
**Cause**: Missing GIDSignIn configuration
**Fix**: Initialize in AppDelegate with Firebase CLIENT_ID

---

## File Reference

- **FirebaseAuthService.swift**: `/AiChat/Services/Auth/FirebaseAuthService.swift`
- **UserAuthInfo.swift**: `/AiChat/Services/Auth/Models/UserAuthInfo.swift`
- **CreateAccountView.swift**: `/AiChat/Core/CreateAccount/CreateAccountView.swift`
- **SettingsView.swift**: `/AiChat/Core/Settings/SettingsView.swift`
- **AppView.swift**: `/AiChat/Core/AppView/AppView.swift`
- **AiChatApp.swift**: `/AiChat/Core/AiChatApp.swift`
