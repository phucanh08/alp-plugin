---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/project-kickoff.md
---

# Workflow khởi tạo dự án

> Bootstrap dự án mới với cấu trúc, docs và kế hoạch đầu tiên.

## Khi nào dùng
Dùng khi bắt đầu repo/module lớn mới.

## Điều kiện trước
- Repo đã khởi tạo
- Có mục tiêu cấp cao

## Các bước
1. Ghi rõ scope và constraints
2. Chạy kickoff: `/alp:bootstrap "<project description>"`
3. Duyệt artifacts plan sinh ra
4. Chốt sequence triển khai trước khi code

## Chuỗi lệnh
- `/alp:bootstrap "..."`
- `/alp:plan "..."` (nếu cần plan chi tiết từng phase)

## Ví dụ prompt
- `/alp:bootstrap "SaaS admin panel with auth, billing, and audit logs"`

## Kết quả mong đợi
- Có hướng dẫn setup có cấu trúc
- Có phased plan sẵn sàng triển khai

## Lỗi thường gặp
- Code ngay khi chưa duyệt plan
- Gom quá nhiều scope vào phase đầu

## Tài liệu liên quan
- [Workflow tính năng mới](./new-feature.md)
- [Quick Start](../quick-start.md)
