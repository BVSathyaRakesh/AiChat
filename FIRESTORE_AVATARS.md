# Firebase Firestore Avatar Implementation

## Overview
Avatars are stored in Firestore with Pollinations AI image URLs (100% free).

## Firestore Structure

```
/avatars/{avatarId}
  - avatarId: String (Primary Key)
  - name: String?
  - charcterOption: CharecterOption?
  - charcterAction: CharecterAction?
  - charcetrLocation: CharcterLocation?
  - profileImageName: String? (Pollinations URL)
  - authorId: String? (Foreign Key - relates to User)
  - dateCreated: Date?
```

## Relationship Key
**`authorId`** is the foreign key that relates avatars to users.

## Available Functions

### 1. Save Avatar (CreateAvatarView.swift)
```swift
private func saveAvatar() async {
    do {
        let uid = try authManager.getAuthId()

        let avatar = AvatarModal(
            avatarId: UUID().uuidString,
            name: avatarName,
            charcterOption: selectedCharacter,
            charcterAction: selectedAction,
            charcetrLocation: selectedLocation,
            profileImageName: generatedImageURL,  // Pollinations URL
            authorId: uid,  // ← Links avatar to user
            dateCreated: .now
        )

        // Save to Firestore
        try await avatarManager.saveAvatarData(avatarModel: avatar)

        print("✅ Avatar saved successfully!")
    } catch {
        print("❌ Error: \(error.localizedDescription)")
    }
}
```

### 2. Fetch User's Avatars (ProfileView.swift)
```swift
private func loadData() async {
    do {
        let uid = try authManager.getAuthId()

        // Get all avatars for current user
        myAVatars = try await avatarManager.fetchUserAvatars(userId: uid)

        print("✅ Loaded \(myAVatars.count) avatars")
    } catch {
        print("❌ Error: \(error.localizedDescription)")
    }
}
```

### 3. Fetch Specific Avatar by ID
```swift
func loadAvatar(avatarId: String) async {
    do {
        if let avatar = try await avatarManager.fetchAvatar(avatarId: avatarId) {
            print("Found avatar: \(avatar.name ?? "unnamed")")
        }
    } catch {
        print("❌ Error: \(error)")
    }
}
```

### 4. Fetch All Avatars (For Explore Page)
```swift
func loadAllAvatars() async {
    do {
        let avatars = try await avatarManager.fetchAllAvatars(limit: 20)
        print("✅ Loaded \(avatars.count) public avatars")
    } catch {
        print("❌ Error: \(error)")
    }
}
```

### 5. Delete Avatar (ProfileView.swift)
```swift
private func onDeleteAvtar(indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    let avatar = myAVatars[index]

    Task {
        do {
            try await avatarManager.deleteAvatar(avatarId: avatar.avatarId)
            myAVatars.remove(at: index)
            print("✅ Avatar deleted")
        } catch {
            print("❌ Error: \(error)")
        }
    }
}
```

## Firestore Queries

### Query by User (authorId)
```swift
db.collection("avatars")
    .whereField("authorId", isEqualTo: userId)
    .order(by: "dateCreated", descending: true)
    .getDocuments()
```

### Query All (Recent First)
```swift
db.collection("avatars")
    .order(by: "dateCreated", descending: true)
    .limit(to: 20)
    .getDocuments()
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /avatars/{avatarId} {
      // Anyone can read
      allow read: if true;

      // Only authenticated users can create
      allow create: if request.auth != null &&
                       request.resource.data.authorId == request.auth.uid;

      // Only owner can update/delete
      allow update, delete: if request.auth != null &&
                               resource.data.authorId == request.auth.uid;
    }
  }
}
```

## Firestore Indexes Required

Create these composite indexes in Firebase Console:

1. **Collection: `avatars`**
   - Field: `authorId` (Ascending)
   - Field: `dateCreated` (Descending)

2. **Collection: `avatars`**
   - Field: `dateCreated` (Descending)

## Implementation Status

✅ **AvatarManager** - All CRUD operations implemented
✅ **CreateAvatarView** - Saves avatars with Pollinations URLs
✅ **ProfileView** - Fetches and displays user's avatars
✅ **Delete Functionality** - Swipe to delete avatars
✅ **Firebase Integration** - Connected to Firestore
✅ **Environment Injection** - AvatarManager injected in app

## Cost Breakdown

- **Firebase Firestore**: Free tier (50K reads/day, 20K writes/day)
- **Image Storage**: FREE (Pollinations URLs, no storage needed)
- **Image Bandwidth**: FREE (Pollinations hosts images)
- **Total Cost**: $0 for personal projects

## Testing

**Mock Service** is available for testing without Firebase:
```swift
#Preview {
    ProfileView()
        .environment(AvatarManager(service: MockAvatarService()))
}
```

## Next Steps

1. Add Firestore security rules to Firebase Console
2. Create composite indexes in Firestore
3. Test create/fetch/delete operations
4. Add error handling UI (alerts/toasts)
5. Add loading states for better UX
