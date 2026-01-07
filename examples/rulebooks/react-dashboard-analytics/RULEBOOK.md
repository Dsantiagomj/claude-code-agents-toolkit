# RULEBOOK - Analytics Dashboard (React)

## Project Overview

**Name:** DataViz Analytics Platform
**Type:** Real-Time Analytics Dashboard
**Description:** Internal analytics platform for monitoring business KPIs, user behavior, and system performance

**Business Context:**
- Internal tool for 50+ team members
- Monitors 100+ business metrics
- Real-time updates via WebSocket
- 15+ departments using daily
- Data sources: PostgreSQL, Redis, 3rd-party APIs

**Key Features:**
- Real-time KPI monitoring
- Custom dashboard builder (drag & drop)
- Advanced filtering & date ranges
- Data export (CSV, PDF, Excel)
- User-specific permissions (RBAC)
- Scheduled reports via email
- Dark mode & customizable themes

---

## Tech Stack

### Frontend
- **Framework:** React 19 (Vite for faster builds)
- **Language:** TypeScript 5.5+ (strict mode)
- **UI Library:** Material-UI (MUI) v6
- **Charts:** Chart.js + react-chartjs-2
- **Tables:** TanStack Table v8 (React Table)
- **State Management:**
  - Redux Toolkit for complex state
  - RTK Query for API calls & caching
- **Forms:** React Hook Form + Yup validation
- **Real-time:** Socket.io client

### Backend Integration
- **API:** REST API (Django backend)
- **WebSocket:** Socket.io for real-time updates
- **Authentication:** JWT tokens (httpOnly cookies)
- **Caching:** RTK Query cache + Redis

### Testing
- **Unit:** Vitest + Testing Library
- **E2E:** Playwright (critical dashboards)
- **Visual Regression:** Chromatic (Storybook)

---

## Folder Structure

```
src/
├── features/
│   ├── dashboard/
│   │   ├── dashboardSlice.ts
│   │   ├── dashboardAPI.ts
│   │   ├── components/
│   │   │   ├── DashboardGrid.tsx
│   │   │   └── WidgetCard.tsx
│   │   └── __tests__/
│   ├── analytics/
│   │   ├── analyticsSlice.ts
│   │   ├── analyticsAPI.ts
│   │   └── components/
│   ├── users/
│   └── reports/
├── components/
│   ├── charts/
│   │   ├── LineChart.tsx
│   │   ├── BarChart.tsx
│   │   └── PieChart.tsx
│   ├── tables/
│   │   └── DataTable.tsx
│   ├── filters/
│   └── layout/
├── services/
│   ├── api.ts
│   ├── websocket.ts
│   └── export.ts
├── hooks/
│   ├── useRealTimeData.ts
│   ├── useExport.ts
│   └── usePermissions.ts
└── utils/
    ├── formatters.ts
    └── calculations.ts
```

---

## Architecture Decisions

### Why Redux Toolkit?
**Decision:** Redux Toolkit instead of Context API or Zustand

**Reasoning:**
- Dashboard state is complex (10+ widgets, filters, date ranges)
- State shared across many components
- Need DevTools for debugging
- RTK Query excellent for data fetching + caching

**Tradeoff:** More boilerplate, but worth it for complex dashboards

---

### Why Material-UI?
**Decision:** MUI v6 instead of building custom components

**Reasoning:**
- 50+ team members means accessibility is critical (MUI has it built-in)
- Needed professional look out-of-the-box
- Theme system for dark mode
- 200+ ready components saved 3 months of development

**Tradeoff:** Larger bundle size (mitigated with tree-shaking)

---

## Real-Time Data Updates

### WebSocket Implementation

```typescript
// services/websocket.ts
import { io, Socket } from 'socket.io-client'
import { store } from '@/app/store'
import { updateMetric } from '@/features/dashboard/dashboardSlice'

let socket: Socket | null = null

export function connectWebSocket(token: string) {
  socket = io(process.env.VITE_WS_URL!, {
    auth: { token }
  })

  // Listen for metric updates
  socket.on('metric:update', (data) => {
    store.dispatch(updateMetric(data))
  })

  // Handle reconnection
  socket.on('reconnect', () => {
    console.log('WebSocket reconnected')
  })
}

export function disconnectWebSocket() {
  socket?.disconnect()
  socket = null
}
```

**Why WebSocket over Polling?**
- Metrics update every 5-30 seconds
- 50 concurrent users = 600 requests/min with polling
- WebSocket: 1 connection per user, push updates
- Saved ~90% bandwidth

---

## State Management Pattern

### Redux Toolkit Slice

```typescript
// features/dashboard/dashboardSlice.ts
import { createSlice, PayloadAction } from '@reduxjs/toolkit'

interface Widget {
  id: string
  type: 'chart' | 'table' | 'metric'
  data: any
  layout: { x: number; y: number; w: number; h: number }
}

interface DashboardState {
  widgets: Widget[]
  selectedDateRange: { start: string; end: string }
  filters: Record<string, any>
  isLoading: boolean
}

const dashboardSlice = createSlice({
  name: 'dashboard',
  initialState: {
    widgets: [],
    selectedDateRange: { start: '', end: '' },
    filters: {},
    isLoading: false
  } as DashboardState,

  reducers: {
    addWidget: (state, action: PayloadAction<Widget>) => {
      state.widgets.push(action.payload)
    },
    updateMetric: (state, action) => {
      const widget = state.widgets.find(w => w.id === action.payload.widgetId)
      if (widget) {
        widget.data = action.payload.data
      }
    },
    setDateRange: (state, action) => {
      state.selectedDateRange = action.payload
    }
  }
})
```

---

## Data Visualization

### Chart Configuration

```typescript
// components/charts/LineChart.tsx
import { Line } from 'react-chartjs-2'
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js'

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend)

export function LineChart({ data, title }: LineChartProps) {
  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { position: 'top' as const },
      title: { display: true, text: title }
    },
    scales: {
      y: {
        beginAtZero: true,
        ticks: {
          callback: (value: number) => formatCurrency(value)
        }
      }
    }
  }

  return (
    <div style={{ height: '400px' }}>
      <Line options={options} data={data} />
    </div>
  )
}
```

**Chart Types Used:**
- **Line Charts:** Revenue trends, user growth
- **Bar Charts:** Department comparisons
- **Pie/Doughnut:** Traffic sources, user segments
- **Area Charts:** Cumulative metrics
- **Scatter:** Correlation analysis

---

## Advanced Table Features

### TanStack Table Implementation

```typescript
// components/tables/DataTable.tsx
import { useReactTable, getCoreRowModel, getPaginationRowModel, getSortedRowModel, getFilteredRowModel } from '@tanstack/react-table'

export function DataTable({ data, columns }: DataTableProps) {
  const [sorting, setSorting] = useState([])
  const [globalFilter, setGlobalFilter] = useState('')

  const table = useReactTable({
    data,
    columns,
    state: { sorting, globalFilter },
    onSortingChange: setSorting,
    onGlobalFilterChange: setGlobalFilter,
    getCoreRowModel: getCoreRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel()
  })

  return (
    <TableContainer>
      {/* Global filter */}
      <TextField
        value={globalFilter}
        onChange={e => setGlobalFilter(e.target.value)}
        placeholder="Search..."
      />

      {/* Table */}
      <Table>
        <TableHead>
          {table.getHeaderGroups().map(headerGroup => (
            <TableRow key={headerGroup.id}>
              {headerGroup.headers.map(header => (
                <TableCell key={header.id} onClick={header.column.getToggleSortingHandler()}>
                  {flexRender(header.column.columnDef.header, header.getContext())}
                  {{
                    asc: ' 🔼',
                    desc: ' 🔽'
                  }[header.column.getIsSorted() as string] ?? null}
                </TableCell>
              ))}
            </TableRow>
          ))}
        </TableHead>
        {/* Body... */}
      </Table>

      {/* Pagination */}
      <TablePagination
        rowsPerPageOptions={[10, 25, 50]}
        component="div"
        count={data.length}
        rowsPerPage={table.getState().pagination.pageSize}
        page={table.getState().pagination.pageIndex}
        onPageChange={(e, page) => table.setPageIndex(page)}
        onRowsPerPageChange={e => table.setPageSize(Number(e.target.value))}
      />
    </TableContainer>
  )
}
```

---

## Performance Optimizations

### 1. Data Virtualization (Large Tables)

```typescript
import { useVirtualizer } from '@tanstack/react-virtual'

// For tables with 10,000+ rows
const virtualizer = useVirtualizer({
  count: rows.length,
  getScrollElement: () => parentRef.current,
  estimateSize: () => 50, // Row height
  overscan: 5
})
```

**Impact:** 10,000 rows render in < 100ms (vs 5s without virtualization)

---

### 2. Memoization for Expensive Calculations

```typescript
const chartData = useMemo(() => {
  return processRawData(rawMetrics) // Expensive calculation
}, [rawMetrics])
```

---

### 3. Code Splitting by Route

```typescript
const Analytics = lazy(() => import('./features/analytics/Analytics'))
const Reports = lazy(() => import('./features/reports/Reports'))

<Suspense fallback={<Loading />}>
  <Routes>
    <Route path="/analytics" element={<Analytics />} />
    <Route path="/reports" element={<Reports />} />
  </Routes>
</Suspense>
```

---

## RBAC (Role-Based Access Control)

### Permission System

```typescript
// hooks/usePermissions.ts
export function usePermissions() {
  const user = useAppSelector(selectCurrentUser)

  const canViewFinancials = user.role === 'ADMIN' || user.role === 'FINANCE'
  const canExportData = user.permissions.includes('export')
  const canEditDashboards = user.permissions.includes('dashboard:edit')

  return {
    canViewFinancials,
    canExportData,
    canEditDashboards
  }
}

// Usage in component
function FinancialWidget() {
  const { canViewFinancials } = usePermissions()

  if (!canViewFinancials) {
    return <PermissionDenied />
  }

  return <Chart data={financialData} />
}
```

**Roles Implemented:**
- **ADMIN:** Full access
- **FINANCE:** Financial metrics only
- **MANAGER:** Department metrics
- **VIEWER:** Read-only

---

## Data Export

### Export to Multiple Formats

```typescript
// services/export.ts
import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'
import * as XLSX from 'xlsx'

export async function exportToCSV(data: any[], filename: string) {
  const csv = data.map(row => Object.values(row).join(',')).join('\n')
  const blob = new Blob([csv], { type: 'text/csv' })
  downloadBlob(blob, `${filename}.csv`)
}

export async function exportToPDF(data: any[], title: string) {
  const doc = new jsPDF()
  doc.text(title, 14, 15)

  autoTable(doc, {
    head: [Object.keys(data[0])],
    body: data.map(row => Object.values(row))
  })

  doc.save(`${title}.pdf`)
}

export async function exportToExcel(data: any[], filename: string) {
  const ws = XLSX.utils.json_to_sheet(data)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, 'Data')
  XLSX.writeFile(wb, `${filename}.xlsx`)
}
```

---

## Environment Variables

```bash
# API
VITE_API_URL="https://api.dataviz.internal"
VITE_WS_URL="wss://ws.dataviz.internal"

# Auth
VITE_JWT_REFRESH_INTERVAL=3600000  # 1 hour

# Features
VITE_ENABLE_EXPORT="true"
VITE_ENABLE_REALTIME="true"
```

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

## Lessons Learned

### 1. WebSocket vs Polling
- **Tried:** Long polling initially
- **Problem:** High server load with 50 users
- **Solution:** Switched to WebSocket
- **Result:** 90% reduction in bandwidth, real-time feel

### 2. State Management Choice
- **Tried:** Context API first
- **Problem:** Too many re-renders with complex state
- **Solution:** Redux Toolkit
- **Result:** Better performance, easier debugging

### 3. Chart Library
- **Tried:** D3.js initially
- **Problem:** Too complex for simple charts
- **Solution:** Chart.js for standard charts, D3 only for custom visualizations
- **Result:** 10x faster development

---

**Last Updated:** 2026-01-07
**Project Status:** Production (2 years)
**Team Size:** 3 developers
**Users:** 50+ internal team members
