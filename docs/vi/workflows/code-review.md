---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/code-review.md
---

# Workflow code review

> Xác nhận chất lượng và độ sẵn sàng trước merge/deploy.

## Khi nào dùng
Dùng trước khi chốt bất kỳ thay đổi đáng kể nào.

## Điều kiện trước
- Đã triển khai xong thay đổi
- Đã chạy test ít nhất một lần

## Các bước
1. Chạy test: `/alp:test`
2. Chạy review: `/alp:review:codebase "review pending changes"`
3. Sửa theo findings và chạy lại test
4. Chạy lại review đến khi sạch

## Chuỗi lệnh
- `/alp:test`
- `/alp:review:codebase "..."`

## Ví dụ prompt
- `/alp:review:codebase "security + maintainability pass"`

## Kết quả mong đợi
- Có review notes hành động được
- Sẵn sàng merge sau fix và re-check

## Lỗi thường gặp
- Xem pass review đầu tiên là cuối cùng
- Merge mà không re-run test sau khi sửa

## Tài liệu liên quan
- [Workflow sửa lỗi](./bug-fixing.md)
- [Workflow cập nhật docs](./docs-update.md)
