import { NextResponse } from "next/server";
import { getServerClient } from "@/lib/supabaseClient";

export const dynamic = "force-dynamic";

export async function POST(req: Request) {
    try {
        const formData = await req.formData();
        const file = formData.get("file") as File | null;
        const bucket = (formData.get("bucket") as string) || "unit_photos";
        const path = formData.get("path") as string;

        if (!file || !path) {
            return NextResponse.json({ ok: false, error: "Missing file or path" }, { status: 400 });
        }

        const supabase = getServerClient();

        // Convert File to Buffer
        const arrayBuffer = await file.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);

        const { error } = await supabase.storage
            .from(bucket)
            .upload(path, buffer, {
                contentType: file.type || "application/octet-stream",
                upsert: true,
            });

        if (error) throw error;

        const { data: pub } = supabase.storage.from(bucket).getPublicUrl(path);

        return NextResponse.json({ ok: true, url: pub.publicUrl });
    } catch (e: any) {
        console.error("Upload error:", e);
        return NextResponse.json({ ok: false, error: e.message }, { status: 500 });
    }
}
