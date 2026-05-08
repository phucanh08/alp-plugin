---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/new-feature.md
---

# Workflow phát triển tính năng mới

> Xây tính năng từ ý tưởng đến triển khai đã kiểm chứng.

## Khi nào dùng
Dùng khi thêm tính năng mới cần plan và verify.

## Điều kiện trước
- Plugin đã load (`/alp:watzup` chạy được)
- Scope tính năng rõ ràng

## Các bước
1. Tạo plan: `/alp:plan "implement <feature>"`
2. Triển khai theo plan đã duyệt
3. Chạy test: `/alp:test`
4. Review: `/alp:review:codebase "review this feature"`

## Chuỗi lệnh
- `/alp:plan "..."`
- `/alp:test`
- `/alp:review:codebase "..."`

## Ví dụ prompt
- `/alp:plan "add audit logging to payment flow"`

## Kết quả mong đợi
- Có artifacts plan
- Có báo cáo test pass/fail
- Có review summary và khuyến nghị

## Lỗi thường gặp
- Bỏ qua bước duyệt plan trước khi code
- Báo done trước khi có kết quả test/review

## Tài liệu liên quan
- [Quick Start](../quick-start.md)
- [Workflow code review](./code-review.md)
