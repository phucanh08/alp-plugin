---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/docs-update.md
---

# Workflow cập nhật tài liệu

> Đồng bộ tài liệu theo thay đổi code.

## Khi nào dùng
Dùng sau khi triển khai feature/fix/thay đổi kiến trúc.

## Điều kiện trước
- Code change đủ rõ để mô tả

## Các bước
1. Xác định behavior và file thay đổi
2. Cập nhật file docs liên quan
3. Dùng trợ giúp nếu cần: `/alp:docs:update`
4. Verify links và command examples

## Chuỗi lệnh
- `/alp:docs:update`

## Ví dụ prompt
- `/alp:docs:update`

## Kết quả mong đợi
- Docs phản ánh đúng behavior hiện tại

## Lỗi thường gặp
- Chỉ sửa README, bỏ qua workflow docs
- Để command examples bị cũ

## Tài liệu liên quan
- [Workflow code review](./code-review.md)
- [Workflow tính năng mới](./new-feature.md)
