# RULEBOOK - React Native Mobile App

## Project Overview

**Name:** React Native Mobile App
**Type:** Cross-Platform Mobile Application
**Description:** Modern mobile app with native performance, built for iOS and Android

**Key Features:**
- Cross-platform (iOS + Android)
- Native performance
- Offline-first architecture
- Push notifications
- Deep linking
- In-app purchases (optional)
- Analytics & crash reporting

---

## Tech Stack

### Mobile Framework
- **Framework:** React Native 0.74+
- **Runtime:** Expo SDK 52
- **Language:** TypeScript 5.5+
- **Navigation:** React Navigation 6.x
- **State Management:** Zustand + React Query
- **UI Library:** React Native Paper or NativeBase
- **Forms:** React Hook Form + Zod

### Backend Integration
- **API:** REST or GraphQL
- **HTTP Client:** Axios or tRPC
- **Real-time:** Firebase or WebSocket
- **Authentication:** Firebase Auth or JWT
- **Push Notifications:** Expo Notifications

### Local Storage
- **AsyncStorage:** Expo SecureStore
- **Database:** WatermelonDB or Realm
- **Cache:** React Query

### Testing
- **Unit Tests:** Jest + Testing Library
- **E2E Tests:** Maestro or Detox
- **Component Tests:** Storybook for React Native

---

## Folder Structure

```
src/
├── app/                   # App navigation setup
│   ├── (tabs)/           # Tab navigator screens
│   └── index.tsx
├── components/
│   ├── ui/               # Reusable UI components
│   ├── forms/            # Form components
│   └── common/           # Shared components
├── screens/              # Screen components
│   ├── auth/
│   ├── home/
│   └── profile/
├── navigation/           # Navigation configuration
├── services/
│   ├── api.ts            # API client
│   ├── storage.ts        # AsyncStorage wrapper
│   └── notifications.ts  # Push notifications
├── stores/               # Zustand stores
├── hooks/                # Custom hooks
├── utils/
│   ├── constants.ts
│   └── helpers.ts
├── types/                # TypeScript types
└── theme/                # Theme configuration

assets/
├── images/
├── fonts/
└── sounds/
```

---

## Code Organization

### Screen Structure
```typescript
// screens/home/HomeScreen.tsx
import { View, Text, FlatList } from 'react-native'
import { useQuery } from '@tanstack/react-query'
import { api } from '@/services/api'

export function HomeScreen() {
  const { data, isLoading } = useQuery({
    queryKey: ['posts'],
    queryFn: api.getPosts
  })

  if (isLoading) return <LoadingSpinner />

  return (
    <View>
      <FlatList
        data={data}
        renderItem={({ item }) => <PostCard post={item} />}
        keyExtractor={(item) => item.id}
      />
    </View>
  )
}
```

---

## Navigation

### React Navigation Setup
```typescript
// navigation/AppNavigator.tsx
import { NavigationContainer } from '@react-navigation/native'
import { createNativeStackNavigator } from '@react-navigation/native-stack'
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs'

const Stack = createNativeStackNavigator()
const Tab = createBottomTabNavigator()

export function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Tabs" component={TabNavigator} />
        <Stack.Screen name="Detail" component={DetailScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}

function TabNavigator() {
  return (
    <Tab.Navigator>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
    </Tab.Navigator>
  )
}
```

---

## State Management

### Zustand Store
```typescript
// stores/authStore.ts
import { create } from 'zustand'
import AsyncStorage from '@react-native-async-storage/async-storage'

interface AuthState {
  user: User | null
  token: string | null
  isAuthenticated: boolean
  login: (email: string, password: string) => Promise<void>
  logout: () => Promise<void>
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  token: null,
  isAuthenticated: false,

  login: async (email, password) => {
    const { user, token } = await api.login(email, password)
    await AsyncStorage.setItem('token', token)
    set({ user, token, isAuthenticated: true })
  },

  logout: async () => {
    await AsyncStorage.removeItem('token')
    set({ user: null, token: null, isAuthenticated: false })
  }
}))
```

---

## Offline-First Architecture

### WatermelonDB Setup
```typescript
// database/schema.ts
import { appSchema, tableSchema } from '@nozbe/watermelondb'

export const schema = appSchema({
  version: 1,
  tables: [
    tableSchema({
      name: 'posts',
      columns: [
        { name: 'title', type: 'string' },
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
      const response = await api.getChanges(lastPulledAt)
      return response.data
    },
    pushChanges: async ({ changes }) => {
      await api.pushChanges(changes)
    }
  })
}
```

---

## Push Notifications

### Expo Notifications
```typescript
// services/notifications.ts
import * as Notifications from 'expo-notifications'
import Constants from 'expo-constants'

export async function registerForPushNotifications() {
  const { status } = await Notifications.requestPermissionsAsync()

  if (status !== 'granted') {
    throw new Error('Permission not granted')
  }

  const token = await Notifications.getExpoPushTokenAsync({
    projectId: Constants.expoConfig?.extra?.eas.projectId
  })

  return token.data
}

// Set notification handler
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true
  })
})
```

---

## Authentication

### Firebase Auth
```typescript
// services/auth.ts
import { initializeApp } from 'firebase/app'
import {
  getAuth,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword
} from 'firebase/auth'

const app = initializeApp(firebaseConfig)
const auth = getAuth(app)

export const authService = {
  login: (email: string, password: string) =>
    signInWithEmailAndPassword(auth, email, password),

  signup: (email: string, password: string) =>
    createUserWithEmailAndPassword(auth, email, password),

  logout: () => auth.signOut()
}
```

---

## Styling & Theming

### React Native Paper Theme
```typescript
// theme/index.ts
import { MD3LightTheme, MD3DarkTheme } from 'react-native-paper'

export const lightTheme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: '#6200ee',
    secondary: '#03dac6'
  }
}

export const darkTheme = {
  ...MD3DarkTheme,
  colors: {
    ...MD3DarkTheme.colors,
    primary: '#bb86fc',
    secondary: '#03dac6'
  }
}
```

---

## Performance Optimization

### Image Optimization
```typescript
import FastImage from 'react-native-fast-image'

<FastImage
  source={{ uri: imageUrl }}
  resizeMode={FastImage.resizeMode.cover}
  style={{ width: 200, height: 200 }}
/>
```

### List Optimization
```typescript
<FlatList
  data={items}
  renderItem={renderItem}
  keyExtractor={(item) => item.id}
  // Performance optimizations
  removeClippedSubviews={true}
  maxToRenderPerBatch={10}
  updateCellsBatchingPeriod={50}
  windowSize={10}
  getItemLayout={(data, index) => ({
    length: ITEM_HEIGHT,
    offset: ITEM_HEIGHT * index,
    index
  })}
/>
```

---

## Testing

### Component Tests
```typescript
// __tests__/HomeScreen.test.tsx
import { render, screen } from '@testing-library/react-native'
import { HomeScreen } from '@/screens/home/HomeScreen'

describe('HomeScreen', () => {
  it('renders posts list', () => {
    render(<HomeScreen />)
    expect(screen.getByText('My Posts')).toBeTruthy()
  })
})
```

---

## MCP Servers

### Mandatory: context7

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "context7-mcp"]
    }
  }
}
```

---

## Active Agents

### Core Agents (10)
- code-reviewer, refactoring-specialist, documentation-engineer
- test-strategist, architecture-advisor, security-auditor
- performance-optimizer, git-workflow-specialist, dependency-manager, project-analyzer

### Stack-Specific Agents (6)
- react-native-mobile-specialist
- react-specialist
- typescript-pro
- jest-testing-specialist
- ui-accessibility
- javascript-modernizer

**Total Active Agents:** 16

---

## Deployment

### EAS Build
```bash
# Install EAS CLI
npm install -g eas-cli

# Configure project
eas build:configure

# Build for iOS
eas build --platform ios

# Build for Android
eas build --platform android

# Submit to stores
eas submit --platform ios
eas submit --platform android
```

---

**Template Version:** 1.0.0
**Last Updated:** 2026-01-07
