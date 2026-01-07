# RULEBOOK - React Admin Dashboard

## Project Overview

**Name:** React Admin Dashboard
**Type:** Admin Panel / Analytics Dashboard
**Description:** Modern admin dashboard with real-time analytics, data visualization, and complex state management

**Key Features:**
- Real-time data updates
- Complex data visualization (charts, graphs)
- Advanced filtering & search
- Role-based access control (RBAC)
- Export functionality (PDF, CSV, Excel)
- Dark mode support
- Responsive design

---

## Tech Stack

### Frontend
- **Framework:** React 19 (Vite)
- **Language:** TypeScript 5.5+
- **UI Library:** Material-UI (MUI) v6
- **Styling:** CSS Modules + MUI theming
- **State Management:** Redux Toolkit + RTK Query
- **Charts:** Chart.js + react-chartjs-2
- **Tables:** TanStack Table (React Table v8)
- **Forms:** React Hook Form + Yup validation
- **Date Handling:** date-fns

### Backend Integration
- **API:** REST API
- **HTTP Client:** Axios with interceptors
- **Real-time:** WebSocket (Socket.io client)
- **Authentication:** JWT tokens
- **Caching:** RTK Query cache

### Testing
- **Unit/Integration:** Vitest + Testing Library
- **E2E:** Playwright
- **Component Testing:** Storybook
- **Coverage:** 75% minimum

### Build & Dev Tools
- **Build Tool:** Vite 5
- **Linting:** ESLint + Prettier
- **Type Checking:** TypeScript strict mode
- **Pre-commit:** Husky + lint-staged

---

## Folder Structure

```
src/
├── app/
│   ├── store.ts           # Redux store configuration
│   └── hooks.ts           # Typed Redux hooks
├── features/              # Feature-based modules
│   ├── auth/
│   │   ├── authSlice.ts
│   │   ├── authAPI.ts
│   │   └── components/
│   ├── dashboard/
│   ├── analytics/
│   └── users/
├── components/
│   ├── layout/            # Layout components
│   ├── common/            # Shared components
│   └── charts/            # Chart components
├── hooks/                 # Custom React hooks
├── services/
│   ├── api.ts             # Axios instance
│   └── websocket.ts       # WebSocket client
├── utils/
│   ├── formatters.ts      # Data formatters
│   ├── validators.ts      # Validation helpers
│   └── constants.ts       # App constants
├── types/                 # TypeScript types
├── styles/
│   ├── theme.ts           # MUI theme
│   └── global.css         # Global styles
└── routes/                # React Router setup
```

---

## Code Organization

### Feature-Based Architecture
Each feature module contains:
- Slice (Redux state)
- API definitions (RTK Query)
- Components
- Types
- Tests

Example:
```
features/users/
├── usersSlice.ts
├── usersAPI.ts
├── components/
│   ├── UsersList.tsx
│   ├── UserDetail.tsx
│   └── UserForm.tsx
├── types.ts
└── __tests__/
```

### Component Structure
```typescript
// features/users/components/UsersList.tsx
import { useAppSelector, useAppDispatch } from '@/app/hooks'
import { selectAllUsers } from '../usersSlice'
import { useGetUsersQuery } from '../usersAPI'
import type { User } from '../types'

export function UsersList() {
  const dispatch = useAppDispatch()
  const { data: users, isLoading } = useGetUsersQuery()

  if (isLoading) return <Skeleton />

  return (
    <DataGrid
      rows={users}
      columns={columns}
      pagination
    />
  )
}
```

---

## State Management

### Redux Toolkit Setup
```typescript
// app/store.ts
import { configureStore } from '@reduxjs/toolkit'
import { setupListeners } from '@reduxjs/toolkit/query'

import authReducer from '@/features/auth/authSlice'
import { usersAPI } from '@/features/users/usersAPI'

export const store = configureStore({
  reducer: {
    auth: authReducer,
    [usersAPI.reducerPath]: usersAPI.reducer
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(usersAPI.middleware)
})

setupListeners(store.dispatch)

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
```

### RTK Query API
```typescript
// features/users/usersAPI.ts
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'
import type { User } from './types'

export const usersAPI = createApi({
  reducerPath: 'usersAPI',
  baseQuery: fetchBaseQuery({ baseUrl: '/api' }),
  tagTypes: ['User'],
  endpoints: (builder) => ({
    getUsers: builder.query<User[], void>({
      query: () => '/users',
      providesTags: ['User']
    }),
    createUser: builder.mutation<User, Partial<User>>({
      query: (body) => ({
        url: '/users',
        method: 'POST',
        body
      }),
      invalidatesTags: ['User']
    })
  })
})

export const { useGetUsersQuery, useCreateUserMutation } = usersAPI
```

---

## Data Visualization

### Chart.js Configuration
```typescript
// components/charts/LineChart.tsx
import { Line } from 'react-chartjs-2'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
} from 'chart.js'

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
)

export function LineChart({ data }: LineChartProps) {
  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { position: 'top' as const }
    }
  }

  return <Line options={options} data={data} />
}
```

### Chart Types Used
- **Line Charts:** Trends over time
- **Bar Charts:** Comparisons
- **Pie/Doughnut:** Distributions
- **Area Charts:** Cumulative data
- **Scatter Plots:** Correlations

---

## Tables & Data Grids

### TanStack Table Setup
```typescript
import { useReactTable, getCoreRowModel } from '@tanstack/react-table'

export function UsersTable({ data }: UsersTableProps) {
  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
    // Pagination
    getPaginationRowModel: getPaginationRowModel(),
    // Sorting
    getSortedRowModel: getSortedRowModel(),
    // Filtering
    getFilteredRowModel: getFilteredRowModel()
  })

  return (
    <TableContainer>
      {/* Table implementation */}
    </TableContainer>
  )
}
```

**Features:**
- Sorting (multi-column)
- Filtering (global + column)
- Pagination (client/server)
- Row selection
- Column visibility
- Export functionality

---

## Authentication & Authorization

### JWT Token Management
```typescript
// services/api.ts
import axios from 'axios'

export const api = axios.create({
  baseUrl: process.env.VITE_API_URL
})

// Request interceptor (add token)
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Response interceptor (handle 401)
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Refresh token or logout
    }
    return Promise.reject(error)
  }
)
```

### Role-Based Access Control
```typescript
// components/ProtectedRoute.tsx
import { Navigate } from 'react-router-dom'
import { useAppSelector } from '@/app/hooks'
import { selectUserRole } from '@/features/auth/authSlice'

interface ProtectedRouteProps {
  children: React.ReactNode
  requiredRoles: string[]
}

export function ProtectedRoute({ children, requiredRoles }: ProtectedRouteProps) {
  const userRole = useAppSelector(selectUserRole)

  if (!requiredRoles.includes(userRole)) {
    return <Navigate to="/unauthorized" />
  }

  return <>{children}</>
}
```

---

## Real-Time Updates

### WebSocket Integration
```typescript
// services/websocket.ts
import { io, Socket } from 'socket.io-client'
import { store } from '@/app/store'
import { updateDashboardData } from '@/features/dashboard/dashboardSlice'

let socket: Socket

export function connectWebSocket() {
  socket = io(process.env.VITE_WS_URL)

  socket.on('dashboard:update', (data) => {
    store.dispatch(updateDashboardData(data))
  })

  socket.on('notification', (notification) => {
    // Handle real-time notifications
  })
}

export function disconnectWebSocket() {
  socket?.disconnect()
}
```

---

## Theming & Dark Mode

### MUI Theme Configuration
```typescript
// styles/theme.ts
import { createTheme } from '@mui/material/styles'

export const lightTheme = createTheme({
  palette: {
    mode: 'light',
    primary: { main: '#1976d2' },
    secondary: { main: '#dc004e' }
  }
})

export const darkTheme = createTheme({
  palette: {
    mode: 'dark',
    primary: { main: '#90caf9' },
    secondary: { main: '#f48fb1' }
  }
})
```

### Dark Mode Toggle
```typescript
// app/themeSlice.ts
import { createSlice } from '@reduxjs/toolkit'

interface ThemeState {
  mode: 'light' | 'dark'
}

const themeSlice = createSlice({
  name: 'theme',
  initialState: { mode: 'light' } as ThemeState,
  reducers: {
    toggleTheme: (state) => {
      state.mode = state.mode === 'light' ? 'dark' : 'light'
    }
  }
})
```

---

## Performance Optimization

### Code Splitting
```typescript
// routes/index.tsx
import { lazy, Suspense } from 'react'

const Dashboard = lazy(() => import('@/features/dashboard/Dashboard'))
const Analytics = lazy(() => import('@/features/analytics/Analytics'))

export function Routes() {
  return (
    <Suspense fallback={<Loading />}>
      <Dashboard />
    </Suspense>
  )
}
```

### Memoization
```typescript
import { useMemo, useCallback } from 'react'

export function UsersList({ users }: UsersListProps) {
  const filteredUsers = useMemo(() =>
    users.filter(user => user.isActive),
    [users]
  )

  const handleDelete = useCallback((id: string) => {
    // Delete logic
  }, [])

  return <DataGrid rows={filteredUsers} />
}
```

---

## Testing Strategy

### Component Tests
```typescript
// features/users/components/__tests__/UsersList.test.tsx
import { render, screen } from '@testing-library/react'
import { Provider } from 'react-redux'
import { store } from '@/app/store'
import { UsersList } from '../UsersList'

describe('UsersList', () => {
  it('renders users table', () => {
    render(
      <Provider store={store}>
        <UsersList />
      </Provider>
    )
    expect(screen.getByRole('table')).toBeInTheDocument()
  })
})
```

### Coverage Requirements
- **Minimum:** 75% overall
- **Critical Features:** 90% (auth, RBAC)
- **Components:** 80%

---

## Environment Variables

```bash
# API
VITE_API_URL="http://localhost:8000/api"
VITE_WS_URL="ws://localhost:8000"

# Auth
VITE_JWT_SECRET=""

# Feature Flags
VITE_ENABLE_ANALYTICS="true"
VITE_ENABLE_EXPORT="true"
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

**Required for:**
- React 19 latest features
- Material-UI v6 updates
- TanStack Table v8 APIs
- Redux Toolkit Query patterns

---

## Active Agents

### Core Agents (10)
- code-reviewer, refactoring-specialist, documentation-engineer
- test-strategist, architecture-advisor, security-auditor
- performance-optimizer, git-workflow-specialist, dependency-manager, project-analyzer

### Stack-Specific Agents (9)
- react-specialist
- typescript-pro
- css-architect
- ui-accessibility
- vitest-specialist
- rest-api-architect
- testing-library-specialist
- storybook-testing-specialist
- javascript-modernizer

**Total Active Agents:** 19

---

## Security

- **XSS Protection:** Content sanitization
- **CSRF:** Token validation
- **Input Validation:** Yup schemas
- **API Security:** JWT + HTTPS only
- **Role-Based Access:** RBAC implementation

---

## Performance Targets

- **First Contentful Paint:** < 1.2s
- **Time to Interactive:** < 2.5s
- **Bundle Size:** < 500KB (gzipped)
- **Chart Render Time:** < 100ms

---

## Accessibility

- **WCAG 2.1 AA:** Full compliance
- **Keyboard Navigation:** All features accessible
- **Screen Readers:** ARIA labels on charts/tables
- **Color Contrast:** 4.5:1 minimum

---

**Template Version:** 1.0.0
**Last Updated:** 2026-01-07
