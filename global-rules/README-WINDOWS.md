# Hướng dẫn chạy Scripts trên Windows

## 📋 Tổng quan

Có 2 script chính trong thư mục `global-rules`:
1. **setup-mcps.sh** - Tải và chuẩn bị các file cần thiết cho MCP setup
2. **mcp-sync.sh** - Đồng bộ và quản lý MCP server configurations

## 🚀 Cách chạy nhanh nhất (Git Bash)

### Bước 1: Mở Git Bash
- Tìm "Git Bash" trong Start Menu
- Hoặc click chuột phải trong thư mục → "Git Bash Here"

### Bước 2: Di chuyển đến thư mục
```bash
cd "D:/New folder/agent-rules-main/global-rules"
```

### Bước 3: Chạy scripts

#### Chạy setup-mcps.sh:
```bash
bash setup-mcps.sh
```

#### Chạy mcp-sync.sh (cần cài jq trước):
```bash
# Cài jq nếu chưa có (với Chocolatey)
choco install jq

# Sau đó chạy
bash mcp-sync.sh
```

## 📝 Chi tiết từng script

### 1. setup-mcps.sh

**Mục đích**: Tải các file cần thiết từ GitHub và chuẩn bị cho việc cài đặt MCP servers.

**Cách chạy**:
```bash
bash setup-mcps.sh
```

**Script sẽ**:
- Tạo thư mục `~/Projects/agent-rules/global-rules`
- Tải `steipete-mcps.md` từ GitHub
- Tải `mcp-sync.sh` từ GitHub
- Tải `mcp-sync-rule.md` từ GitHub
- Trích xuất các script cài đặt từ documentation

### 2. mcp-sync.sh

**Mục đích**: Đồng bộ và quản lý MCP server configurations giữa các ứng dụng (Cursor, Claude Desktop, VS Code, Windsurf).

**Yêu cầu**: Cần cài `jq` (JSON processor)

**Cài jq trên Windows**:
```powershell
# Với Chocolatey
choco install jq

# Hoặc tải từ: https://stedolan.github.io/jq/download/
# Giải nén và thêm vào PATH
```

**Cách sử dụng**:

1. **Liệt kê tất cả MCP servers**:
```bash
bash mcp-sync.sh
# hoặc
bash mcp-sync.sh --list
```

2. **Xem help**:
```bash
bash mcp-sync.sh --help
```

3. **Chuyển server từ local sang global config**:
```bash
bash mcp-sync.sh --to-global peekaboo --app cursor
```

4. **Chuyển server từ global sang local config**:
```bash
bash mcp-sync.sh --to-local peekaboo --app cursor
```

## ⚠️ Lưu ý quan trọng

### Đường dẫn trên Windows

Script `mcp-sync.sh` gốc được viết cho macOS với đường dẫn:
- `~/Library/Application Support/Claude/...`

Trên Windows, đường dẫn thực tế là:
- **Cursor**: `%USERPROFILE%\.cursor\mcp.json` hoặc `C:\Users\<YourName>\.cursor\mcp.json`
- **Claude Desktop**: `%APPDATA%\Claude\claude_desktop_config.json` hoặc `C:\Users\<YourName>\AppData\Roaming\Claude\claude_desktop_config.json`

### Giải pháp

Tôi đã tạo file `mcp-sync-windows.sh` với đường dẫn đã được điều chỉnh cho Windows. Bạn có thể dùng file này thay vì file gốc.

## 🔧 Cài đặt dependencies

### jq (JSON processor)

**Windows với Chocolatey**:
```powershell
choco install jq
```

**Windows thủ công**:
1. Tải từ: https://stedolan.github.io/jq/download/
2. Giải nén `jq.exe`
3. Thêm vào PATH hoặc đặt trong thư mục có trong PATH

**Kiểm tra đã cài chưa**:
```bash
jq --version
```

### curl (thường có sẵn trong Git Bash)

Kiểm tra:
```bash
curl --version
```

## 🐛 Troubleshooting

### Lỗi "jq: command not found"
- Cài jq theo hướng dẫn trên
- Đảm bảo jq có trong PATH

### Lỗi "No such file or directory"
- Kiểm tra đường dẫn có đúng không
- Trên Windows, dùng dấu `/` thay vì `\` trong Git Bash

### Script không chạy được
- Đảm bảo đang dùng Git Bash, không phải PowerShell hoặc CMD
- Thử chạy với `bash script-name.sh` thay vì `./script-name.sh`

## 📚 Tài liệu tham khảo

- Git Bash: https://git-scm.com/download/win
- jq: https://stedolan.github.io/jq/
- Chocolatey: https://chocolatey.org/
