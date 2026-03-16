import { NextResponse } from "next/server";
// Таблица rent_daily_units удалена в новой схеме БД. Этот маршрут деактивирован.
export async function GET() {
  return NextResponse.json({ error: "Этот раздел удален. Используйте /api/units." }, { status: 410 });
}
export async function POST() {
  return NextResponse.json({ error: "Этот раздел удален. Используйте /api/units." }, { status: 410 });
}
