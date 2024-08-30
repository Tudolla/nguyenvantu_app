# Ứng dụng hỗ trợ công việc trong công ty : Monstarlab
1. Các công nghệ sử dụng :
- Flutter
  - Thiết kế giao diện,
  - Kết nối, tương tác với Server thông qua giao thức http,...
  - Quản lý trạng thái nội bộ trong ứng dụng
- Riverpod
  - Quản lý trạng thái trong ứng dụng
- Django Rest Framework
  - Restful API
  - Database Interaction : Django sử dụng ORM để tương tác với MySQL database
  - Bussiness Logic : xử lý logic nghiệp vụ ở phía server
  - Authentication & Authorization: Quản lý đăng nhập, đăng xuất và kiểm soát quyền truy cập vào các tài nguyên khác nhau
  - File Handling
- Mysql
2. Kiến trúc và thiết kế trong ứng dụng
- Mô hình MVVM kết hợp Repository, Service
# Các chức năng có trong ứng dụng

| Date       | Features                                 | Status     |      Detail           |
|------------|------------------------------------------|------------|-----------------------|
| 29-8-2024  | Đăng nhập, xem thông tin cá nhân         | Completed  |                       | 
| 30-8-2024  | Chỉnh sửa thông tin cá nhân              | Error      | 404 bad request       |
|            | Tính số ngày công đã làm                 | Processing |                       |
|            | Gửi ý kiến đóng góp                      | Processing |                       |
|            | Xem giới thiệu về công ty                | Processing |                       |
|            | Nhận thông báo từ Admin                  | Processing |                       |
|            | Xem những thành tích nổi bật             | Processing |
|            | Tìm kiếm thành viên trong nhóm           | Processing |
