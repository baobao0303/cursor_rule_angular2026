# Hướng dẫn chạy Scripts trên Windows

## Cách 1: Sử dụng Git Bash (Khuyến nghị)

### Bước 1: Cài đặt Git Bash
Nếu chưa có, tải và cài đặt Git for Windows: https://git-scm.com/download/win

### Bước 2: Mở Git Bash và chạy scripts

```bash
# Di chuyển đến thư mục global-rules
cd "D:/New folder/agent-rules-main/global-rules"

# Chạy setup-mcps.sh
bash setup-mcps.sh

# Chạy mcp-sync.sh (cần cài jq trước)
bash mcp-sync.sh
```

### Bước 3: Cài đặt jq (cần cho mcp-sync.sh)
```bash
# Sử dụng Chocolatey (nếu đã cài)
choco install jq

# Hoặc tải từ: https://stedolan.github.io/jq/download/
# Giải nén và thêm vào PATH
```

## Cách 2: Sử dụng WSL (Windows Subsystem for Linux)

### Bước 1: Cài đặt WSL
```powershell
wsl --install
```

### Bước 2: Chạy scripts trong WSL
```bash
# Mở WSL terminal
cd /mnt/d/New\ folder/agent-rules-main/global-rules

# Cài jq
sudo apt update
sudo apt install jq

# Chạy scripts
bash setup-mcps.sh
bash mcp-sync.sh
```

## Cách 3: Sử dụng PowerShell (Cần chỉnh sửa)

Các scripts này được viết cho bash, nhưng bạn có thể chạy một số lệnh cơ bản trong PowerShell.

### Lưu ý quan trọng:
- `mcp-sync.sh` có đường dẫn macOS (`~/Library/Application Support/...`)
- Trên Windows, đường dẫn sẽ khác:
  - Cursor: `%USERPROFILE%\.cursor\mcp.json`
  - Claude Desktop: `%APPDATA%\Claude\claude_desktop_config.json`

## Script mcp-sync.sh - Cách sử dụng

### Liệt kê tất cả MCP servers:
```bash
bash mcp-sync.sh
# hoặc
bash mcp-sync.sh --list
```

### Xem help:
```bash
bash mcp-sync.sh --help
```

### Chuyển server từ local sang global:
```bash
bash mcp-sync.sh --to-global peekaboo --app cursor
```

### Chuyển server từ global sang local:
```bash
bash mcp-sync.sh --to-local peekaboo --app cursor
```

## Script setup-mcps.sh - Cách sử dụng

Script này sẽ:
1. Tạo thư mục `~/Projects/agent-rules/global-rules`
2. Tải các file cần thiết từ GitHub
3. Trích xuất các script cài đặt từ documentation

Chạy đơn giản:
```bash
bash setup-mcps.sh
```

## Yêu cầu hệ thống

- **jq**: Cần cho `mcp-sync.sh` để xử lý JSON
  - Windows: Tải từ https://stedolan.github.io/jq/download/
  - Hoặc dùng Chocolatey: `choco install jq`
- **curl**: Thường có sẵn trong Git Bash
- **awk**: Có sẵn trong Git Bash

## Troubleshooting

### Lỗi "jq not found"
```bash
# Windows với Chocolatey
choco install jq

# Hoặc tải binary từ: https://github.com/jqlang/jq/releases
# Thêm vào PATH
```

### Lỗi đường dẫn
Scripts được viết cho macOS. Trên Windows, bạn có thể cần chỉnh sửa đường dẫn trong `mcp-sync.sh`:
- Thay `$HOME/Library/Application Support/` bằng `%APPDATA%\` hoặc `$APPDATA/`
