---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/bug-fixing.md
---

# Workflow sửa lỗi

> Tái hiện lỗi, debug, sửa tối thiểu và verify bằng bằng chứng.

## Khi nào dùng
Dùng cho bug runtime, regression, hoặc test fail.

## Điều kiện trước
- Có mô tả tái hiện lỗi (log/error/failing case)

## Các bước
1. Tái hiện lỗi và tóm tắt context
2. Chạy fix plan: `/alp:plan "fix <issue>"`
3. Sửa tối thiểu
4. Chạy test xác nhận: `/alp:test`
5. Review ảnh hưởng: `/alp:review:codebase "check bug fix impact"`

## Chuỗi lệnh
- `/alp:plan "fix <issue>"`
- `/alp:test`
- `/alp:review:codebase "..."`

## Ví dụ prompt
- `/alp:plan "fix login API returns 500 when token is expired"`

## Kết quả mong đợi
- Có giả thuyết root cause
- Có fix đã verify bằng test

## Lỗi thường gặp
- Sửa khi chưa tái hiện được lỗi
- Không test đường đi liên quan

## Tài liệu liên quan
- [Workflow code review](./code-review.md)
- [Workflow cập nhật docs](./docs-update.md)
