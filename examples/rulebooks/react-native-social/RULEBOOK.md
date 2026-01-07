# RULEBOOK - Social Media App (React Native)

## Project Overview

**Name:** ConnectMe Social Platform
**Type:** Mobile Social Media Application
**Description:** Social networking app with posts, stories, messaging, and real-time notifications

**Business Context:**
- 500,000+ active users
- 2M+ posts/month
- Real-time chat & notifications
- iOS & Android (single codebase)
- Team: 8 mobile developers

**Key Features:**
- User profiles & follow system
- Photo/video posts with filters
- Stories (24-hour expiry)
- Real-time messaging (1-on-1 & groups)
- Push notifications
- Offline mode (post drafts, read cached content)
- In-app camera with filters
- Deep linking (share posts via URL)

---

## Tech Stack

### Mobile
- **Framework:** React Native 0.74
- **Runtime:** Expo SDK 52 (managed workflow)
- **Language:** TypeScript 5.5+
- **Navigation:** React Navigation 6.x
- **State:** Zustand + React Query
- **UI:** React Native Paper
- **Forms:** React Hook Form + Zod

### Backend Integration
- **API:** GraphQL (Apollo Client)
- **Real-time:** Firebase Realtime Database (chat)
- **Auth:** Firebase Authentication
- **Storage:** Firebase Storage (images/videos)
- **Push:** Firebase Cloud Messaging + Expo Notifications
- **Analytics:** Firebase Analytics

### Local Storage
- **Offline DB:** WatermelonDB (SQLite)
- **Cache:** React Query + AsyncStorage
- **Secure Storage:** Expo SecureStore (tokens)

---

## Folder Structure

```
src/
├── screens/
│   ├── auth/
│   │   ├── LoginScreen.tsx
│   │   └── SignupScreen.tsx
│   ├── feed/
│   │   ├── FeedScreen.tsx
│   │   └── PostDetailScreen.tsx
│   ├── profile/
│   ├── chat/
│   └── camera/
├── components/
│   ├── Post.tsx
│   ├── Story.tsx
│   ├── Message.tsx
│   └── Camera.tsx
├── navigation/
│   ├── AppNavigator.tsx
│   └── TabNavigator.tsx
├── services/
│   ├── api.ts           # GraphQL client
│   ├── firebase.ts
│   ├── notifications.ts
│   └── camera.ts
├── stores/
│   ├── authStore.ts
│   ├── chatStore.ts
│   └── feedStore.ts
├── database/
│   ├── schema.ts        # WatermelonDB schema
│   └── models/
└── hooks/
    ├── useAuth.ts
    ├── useChat.ts
    └── useOfflineSync.ts
```

---

## Offline-First Architecture

### WatermelonDB Implementation

```typescript
// database/schema.ts
import { appSchema, tableSchema } from '@nozbe/watermelondb'

export const schema = appSchema({
  version: 1,
  tables: [
    tableSchema({
      name: 'posts',
      columns: [
        { name: 'user_id', type: 'string', isIndexed: true },
        { name: 'content', type: 'string' },
        { name: 'image_url', type: 'string', isOptional: true },
        { name: 'likes_count', type: 'number' },
        { name: 'synced', type: 'boolean' },
        { name: 'created_at', type: 'number' },
        { name: 'updated_at', type: 'number' }
      ]
    }),
    tableSchema({
      name: 'comments',
      columns: [
        { name: 'post_id', type: 'string', isIndexed: true },
        { name: 'user_id', type: 'string' },
        { name: 'content', type: 'string' },
        { name: 'synced', type: 'boolean' },
        { name: 'created_at', type: 'number' }
      ]
    })
  ]
})
```

### Sync Strategy

```typescript
// services/sync.ts
import { synchronize } from '@nozbe/watermelondb/sync'
import { database } from '@/database'

export async function syncDatabase() {
  await synchronize({
    database,
    pullChanges: async ({ lastPulledAt }) => {
      const response = await apolloClient.query({
        query: GET_CHANGES,
        variables: { lastPulledAt }
      })

      return {
        changes: response.data.changes,
        timestamp: response.data.timestamp
      }
    },
    pushChanges: async ({ changes }) => {
      await apolloClient.mutate({
        mutation: PUSH_CHANGES,
        variables: { changes }
      })
    }
  })
}
```

**Why Offline-First?**
- Users on subway/poor connection
- Instant UI updates (no loading states)
- Better UX: works without internet
- Sync happens in background

---

## Real-Time Chat

### Firebase Realtime Database

```typescript
// services/chat.ts
import database from '@react-native-firebase/database'

export function subscribeToChat(chatId: string, onMessage: (msg: Message) => void) {
  const chatRef = database().ref(`/chats/${chatId}/messages`)

  return chatRef.on('child_added', (snapshot) => {
    const message = snapshot.val()
    onMessage(message)
  })
}

export async function sendMessage(chatId: string, message: Message) {
  const chatRef = database().ref(`/chats/${chatId}/messages`)
  await chatRef.push({
    text: message.text,
    userId: message.userId,
    timestamp: database.ServerValue.TIMESTAMP
  })
}
```

### Chat Store (Zustand)

```typescript
// stores/chatStore.ts
import { create } from 'zustand'

interface ChatStore {
  conversations: Conversation[]
  activeChat: string | null
  messages: Record<string, Message[]>
  sendMessage: (chatId: string, text: string) => Promise<void>
  subscribeToChat: (chatId: string) => void
}

export const useChatStore = create<ChatStore>((set, get) => ({
  conversations: [],
  activeChat: null,
  messages: {},

  sendMessage: async (chatId, text) => {
    const message = {
      text,
      userId: getUserId(),
      timestamp: Date.now()
    }

    // Optimistic update
    set(state => ({
      messages: {
        ...state.messages,
        [chatId]: [...(state.messages[chatId] || []), message]
      }
    }))

    // Send to Firebase
    await sendMessage(chatId, message)
  },

  subscribeToChat: (chatId) => {
    subscribeToChat(chatId, (message) => {
      set(state => ({
        messages: {
          ...state.messages,
          [chatId]: [...(state.messages[chatId] || []), message]
        }
      }))
    })
  }
}))
```

---

## Push Notifications

### Setup & Permissions

```typescript
// services/notifications.ts
import * as Notifications from 'expo-notifications'
import * as Device from 'expo-device'
import Constants from 'expo-constants'

export async function registerForPushNotifications() {
  if (!Device.isDevice) {
    return null
  }

  const { status: existingStatus } = await Notifications.getPermissionsAsync()
  let finalStatus = existingStatus

  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync()
    finalStatus = status
  }

  if (finalStatus !== 'granted') {
    throw new Error('Push notification permission denied')
  }

  const token = await Notifications.getExpoPushTokenAsync({
    projectId: Constants.expoConfig?.extra?.eas.projectId
  })

  // Send token to backend
  await savePushToken(token.data)

  return token.data
}

// Handle notifications
Notifications.setNotificationHandler({
  handleNotification: async (notification) => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true
  })
})
```

---

## Camera & Image Processing

### expo-camera Implementation

```typescript
// components/Camera.tsx
import { Camera, CameraType } from 'expo-camera'
import * as ImageManipulator from 'expo-image-manipulator'

export function CameraScreen() {
  const [type, setType] = useState(CameraType.back)
  const [permission, requestPermission] = Camera.useCameraPermissions()
  const cameraRef = useRef<Camera>(null)

  const takePicture = async () => {
    if (cameraRef.current) {
      const photo = await cameraRef.current.takePictureAsync()

      // Apply filter/resize
      const manipulated = await ImageManipulator.manipulateAsync(
        photo.uri,
        [{ resize: { width: 1080 } }],
        { compress: 0.8, format: ImageManipulator.SaveFormat.JPEG }
      )

      // Upload to Firebase Storage
      await uploadImage(manipulated.uri)
    }
  }

  return (
    <Camera
      ref={cameraRef}
      style={{ flex: 1 }}
      type={type}
    >
      <Button onPress={takePicture}>Take Photo</Button>
    </Camera>
  )
}
```

---

## Performance Optimizations

### 1. Image Optimization

```typescript
import FastImage from 'react-native-fast-image'

<FastImage
  source={{
    uri: post.imageUrl,
    priority: FastImage.priority.normal,
    cache: FastImage.cacheControl.immutable
  }}
  style={{ width: 400, height: 400 }}
  resizeMode={FastImage.resizeMode.cover}
/>
```

### 2. List Virtualization

```typescript
import { FlashList } from '@shopify/flash-list'

<FlashList
  data={posts}
  renderItem={({ item }) => <Post post={item} />}
  estimatedItemSize={400}
  // Much faster than FlatList for large lists
/>
```

### 3. Lazy Loading Images

```typescript
const [isVisible, setIsVisible] = useState(false)

<InView onChange={setIsVisible}>
  {isVisible ? (
    <FastImage source={{ uri: post.imageUrl }} />
  ) : (
    <Skeleton width={400} height={400} />
  )}
</InView>
```

---

## Deep Linking

```typescript
// app.json
{
  "expo": {
    "scheme": "connectme",
    "ios": {
      "associatedDomains": ["applinks:connectme.app"]
    },
    "android": {
      "intentFilters": [
        {
          "action": "VIEW",
          "data": [
            {
              "scheme": "https",
              "host": "connectme.app",
              "pathPrefix": "/post"
            }
          ],
          "category": ["BROWSABLE", "DEFAULT"]
        }
      ]
    }
  }
}
```

```typescript
// navigation/linking.ts
const linking = {
  prefixes: ['connectme://', 'https://connectme.app'],
  config: {
    screens: {
      PostDetail: 'post/:id',
      Profile: 'user/:username',
      Chat: 'chat/:chatId'
    }
  }
}

// Handle deep link
Linking.addEventListener('url', ({ url }) => {
  // connectme://post/abc123
  // navigates to PostDetailScreen with id=abc123
})
```

---

## Active Agents

### Core (10)
- code-reviewer, refactoring-specialist, documentation-engineer
- test-strategist, architecture-advisor, security-auditor
- performance-optimizer, git-workflow-specialist, dependency-manager, project-analyzer

### Stack-Specific (6)
- react-native-mobile-specialist
- react-specialist
- typescript-pro
- jest-testing-specialist
- ui-accessibility
- javascript-modernizer

**Total Active Agents:** 16

---

## Key Decisions

### 1. Expo vs Bare React Native
- **Chose:** Expo
- **Why:** Faster development, OTA updates, easier CI/CD
- **Tradeoff:** Some limitations (mitigated with custom dev clients)

### 2. WatermelonDB vs AsyncStorage
- **Chose:** WatermelonDB
- **Why:** Handles 10,000+ posts, fast queries, reactive
- **Tradeoff:** Larger bundle size (worth it for performance)

### 3. Firebase vs Custom Backend
- **Chose:** Firebase for real-time features
- **Why:** Real-time chat out-of-the-box, offline support
- **Tradeoff:** Vendor lock-in (acceptable for speed)

---

**Last Updated:** 2026-01-07
**Project Status:** Production (1.5 years)
**Team Size:** 8 mobile developers
**Users:** 500,000+ active users
