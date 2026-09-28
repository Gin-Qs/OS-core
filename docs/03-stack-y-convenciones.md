# 03 · Stack y convenciones

## Stack (confirmado el 24/09/2026 · ver `ADR-0005`)
| Capa | Tecnología |
|---|---|
| Web y PWA | Next.js App Router, TypeScript estricto, Serwist (PWA) |
| UI | Tailwind CSS, shadcn/ui, lucide-react, TanStack Table, React Hook Form, Zod |
| Backend | Server Actions y Route Handlers de Next.js; funciones SQL y Edge Functions de Supabase |
| Base de datos | Supabase PostgreSQL con RLS; migraciones con Supabase CLI |
| Auth | Supabase Auth (correo + TOTP 2FA) |
| Archivos | Supabase Storage |
| Secretos | Supabase Vault |
| Tareas programadas | pg_cron + Edge Functions |
| Correo | Resend |
| XML | fast-xml-parser (lectura) y xmlbuilder2 (construcción) |
| Números | decimal.js para cálculos fiscales y contables |
| Pruebas | Vitest (unidad), Playwright (e2e), pgTAP o pruebas SQL para RLS |
| Calidad | ESLint + eslint-plugin-boundaries, Prettier, TypeScript noUncheckedIndexedAccess |
| Hosting | Vercel (web) + Supabase (datos) |
| Paquetes | pnpm |

## Convenciones
- Carpetas por módulo: `contracts/ domain/ application/ infra/ ui/ subscribers/ __tests__/`.
- `contracts/` exporta solo tipos y funciones de lectura para otros módulos.
- Nombres de tablas en plural, snake_case, en español. Claves primarias `id uuid default gen_random_uuid()`.
- Columnas comunes: `empresa_id`, `creado_en`, `creado_por`, `actualizado_en`, `actualizado_por`, `eliminado_en` (borrado lógico donde aplique).
- Folios: secuencia por empresa y tipo (`plataforma.folios`).
- Estados como `text` con `check` (no enums de Postgres, para migrar fácil).
- Eventos: `modulo.entidad_verbo_pasado` (ej. `operaciones.orden_cerrada`) con `version`.
- Permisos: `area.recurso` + acción (`ver, crear, editar, aprobar, eliminar, exportar`).
- Errores de dominio tipados; mensajes de UI en español.
- Commits: `feat(modulo): ...`, `fix(modulo): ...`.
