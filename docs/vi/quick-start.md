---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/quick-start.md
---

# Quick Start

> Chạy alp và thực hiện workflow đầu tiên trong dưới 10 phút.

## Khi nào dùng
Dùng khi thiết lập alp lần đầu trên máy.

## Điều kiện trước
- Đã cài Claude Code
- Có local plugin path: `D:\Projects\alp-plugin`

## Các bước
1. Mở Claude với plugin dir:
   ```bash
   claude --plugin-dir D:\Projects\alp-plugin
   ```
2. Kiểm tra namespace command:
   ```text
   /alp:watzup
   ```
3. Chạy command plan đầu tiên:
   ```text
   /alp:plan "implement feature X"
   ```

## Chuỗi lệnh
1. `claude --plugin-dir D:\Projects\alp-plugin`
2. `/alp:watzup`
3. `/alp:plan "..."`

## Ví dụ prompt
- `/alp:plan "build user profile settings page"`

## Kết quả mong đợi
- `/alp:watzup` trả trạng thái project.
- `/alp:plan` bắt đầu flow tạo plan.

## Lỗi thường gặp
- Dùng `/watzup` thay vì `/alp:watzup`
- Chạy Claude mà không thêm `--plugin-dir`

## Tài liệu liên quan
- [Workflow phát triển tính năng](./workflows/new-feature.md)
- [Mục lục docs alp](./index.md)
