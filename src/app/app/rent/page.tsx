import { redirect } from "next/navigation";

// Раздел аренды удалён — перенаправляем на продажи
export default function RentPage() {
  redirect("/app/sales");
}
