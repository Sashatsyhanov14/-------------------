import { z } from 'zod';

// Zod schema for creating/editing a unit (matches public.units table)
export const unitSchema = z.object({
  city: z.string().min(1),
  address: z.string().optional(),
  type: z.string().default('apartment'),
  rooms: z.union([z.string(), z.number()]).optional(),
  floor: z.number().int().optional(),
  floors_total: z.number().int().optional(),
  area_m2: z.number().positive().optional(),
  price: z.number().positive().optional(),
  status: z.enum(['available', 'reserved', 'sold']).default('available'),
  title: z.string().optional(),
  description: z.string().max(4000).optional(),
  features: z.array(z.string()).optional(),
  project_id: z.string().uuid().nullable().optional(),
  is_active: z.boolean().default(true),
});

export type UnitFormData = z.infer<typeof unitSchema>;
