import { NextResponse } from "next/server";
// Таблица rental_bookings удалена в новой схеме БД.
export async function GET() {
  return NextResponse.json({ error: "Этот раздел удален." }, { status: 410 });
}
export async function POST() {
  return NextResponse.json({ error: "Этот раздел удален." }, { status: 410 });
}
