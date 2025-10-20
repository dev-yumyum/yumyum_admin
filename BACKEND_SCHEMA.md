# YumYum CRM 백엔드 스키마 정의서

## 1. 회원 관리 (Member)

### 테이블명: `members`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "M001" |
| memberId | String | ✓ | 회원 로그인 ID | "user@example.com" |
| memberName | String | | 회원명 | "김민수" |
| email | String | | 이메일 | "user@example.com" |
| phone | String | | 전화번호 | "010-1234-5678" |
| nickname | String | | 닉네임 | "맛집러버" |
| profileImage | String | | 프로필 이미지 URL | "https://..." |
| registrationDate | String | ✓ | 가입일 | "2024-09-01" |
| lastLoginDate | String | | 최근 로그인일 | "2024-09-14" |
| status | String | ✓ | 회원 상태 | ACTIVE, INACTIVE, SUSPENDED, WITHDRAWN |
| grade | String | | 회원 등급 | BRONZE, SILVER, GOLD, VIP |
| totalOrders | Int | | 총 주문 수 | 47 |
| totalAmount | String | | 총 주문 금액 | "342500" |
| pointBalance | Int | | 포인트 잔액 | 2450 |
| address | String | | 주소 | "서울시 강남구..." |
| addressDetail | String | | 상세주소 | "101동 101호" |
| birthDate | String | | 생년월일 | "1990-01-01" |
| gender | String | | 성별 | M, F, OTHER |
| isMarketingAgreed | Boolean | | 마케팅 수신 동의 | true/false |
| isPushAgreed | Boolean | | 푸시 알림 동의 | true/false |
| favoriteCategory | String | | 선호 카테고리 | "KOREAN" |
| withdrawalReason | String | | 탈퇴 사유 | "..." |
| withdrawalDate | String | | 탈퇴일 | "2024-09-15" |
| registrationType | String | | 가입 유형 | 카카오톡, 이메일, 애플 |

---

## 2. 사업자 관리 (Business)

### 테이블명: `businesses`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "B001" |
| businessName | String | ✓ | 사업자명 | "맛있는식당" |
| businessNumber | String | ✓ | 사업자번호 | "123-45-67890" |
| businessType | String | ✓ | 사업자 유형 | "개인/법인" |
| ownerName | String | ✓ | 대표자명 | "김사장" |
| businessLocation | String | | 사업장 소재지 | "서울시" |
| businessLocationDetail | String | | 사업장 소재지 상세 | "강남구..." |
| businessAddress | String | | 사업자 주소 | "서울시 강남구..." |
| businessAddressDetail | String | | 사업자 주소 상세 | "101호" |
| businessCategory | String | | 업종 분류 | "음식점" |
| businessItem | String | | 종목 | "한식" |
| ownerPhone | String | | 대표자 전화번호 | "010-1234-5678" |
| ownerEmail | String | | 대표자 이메일 | "owner@example.com" |
| registrationDate | String | ✓ | 등록일 | "2024-01-01" |
| status | String | ✓ | 상태 | PENDING, APPROVED, REJECTED |
| businessLicenseUrl | String | | 사업자등록증 URL | "https://..." |
| businessLicenseFileName | String | | 사업자등록증 파일명 | "license.pdf" |
| bankName | String | | 은행명 | "국민은행" |
| accountNumber | String | | 계좌번호 | "1234567890" |
| accountHolder | String | | 예금주 | "김사장" |
| accountVerified | Boolean | | 계좌 인증 여부 | true/false |
| bankBookUrl | String | | 통장 사본 URL | "https://..." |
| bankBookFileName | String | | 통장 사본 파일명 | "bankbook.pdf" |
| loginId | String | | 로그인 ID | "business001" |
| password | String | | 비밀번호 (암호화) | "..." |
| connectedStoreIds | List<String> | | 연결된 매장 ID 목록 | ["S001", "S002"] |

---

## 3. 매장 관리 (Store)

### 테이블명: `stores`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "S001" |
| businessId | String | ✓ | 사업자 ID | "B001" |
| storeName | String | ✓ | 매장명 | "맛있는식당 강남점" |
| storeAddress | String | ✓ | 매장 주소 | "서울시 강남구..." |
| storeAddressDetail | String | | 매장 주소 상세 | "1층" |
| storePhone | String | | 매장 전화번호 | "02-1234-5678" |
| storeDescription | String | | 매장 소개 | "최고의 맛..." |
| registrationDate | String | ✓ | 등록일 | "2024-01-01" |
| status | String | ✓ | 매장 상태 | OPEN, CLOSED, OUT_OF_BUSINESS |
| operatingHours | String | | 영업시간 | "10:00-22:00" |
| deliveryRadius | String | | 배달 반경(km) | "3" |
| isDeliveryAvailable | Boolean | ✓ | 배달 가능 여부 | true/false |
| isPickupAvailable | Boolean | ✓ | 포장 가능 여부 | true/false |
| minimumOrderAmount | String | | 최소 주문 금액 | "15000" |
| deliveryFee | String | | 배달비 | "3000" |
| storeImages | List<String> | | 매장 이미지 URL 목록 | ["https://...", ...] |
| storeIntroImage | String | | 매장 소개 이미지 URL | "https://..." |
| latitude | Double | | 위도 | 37.1234 |
| longitude | Double | | 경도 | 127.1234 |
| businessName | String | | 소속 사업자명 | "맛있는식당" |
| menuCount | Int | | 메뉴 개수 | 25 |
| lastOrderDate | String | | 마지막 주문일 | "2024-09-14" |

---

## 4. 메뉴 관리 (Menu)

### 테이블명: `menu_items`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "MI001" |
| name | String | ✓ | 메뉴명 | "김치찌개" |
| storeId | String | ✓ | 매장 ID | "S001" |
| menuGroupId | String | ✓ | 메뉴 그룹 ID | "MG001" |
| price | Int | ✓ | 가격 | 8000 |
| description | String | | 메뉴 설명 | "정성스럽게..." |
| imageUrl | String | | 메뉴 이미지 URL | "https://..." |
| status | String | ✓ | 메뉴 상태 | SELLING, SOLD_OUT, HIDDEN |
| sortOrder | Int | ✓ | 정렬 순서 | 1 |
| createdDate | String | ✓ | 생성일 | "2024-01-01" |
| lastModifiedDate | String | | 최종 수정일 | "2024-09-01" |
| optionGroupIds | List<String> | ✓ | 연결된 옵션 그룹 ID | ["OG001", "OG002"] |

---

## 5. 주문/매출 관리 (Sales)

### 테이블명: `orders`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "O001" |
| orderId | String | ✓ | 주문 ID | "O001" |
| orderNumber | String | ✓ | 주문번호 | "O202409140001" |
| storeId | String | | 매장 ID | "S001" |
| storeName | String | | 매장명 | "맛있는식당" |
| businessId | String | | 사업자 ID | "B001" |
| businessName | String | | 사업자명 | "맛있는식당" |
| memberId | String | | 회원 ID | "M001" |
| memberName | String | | 회원명 | "김민수" |
| customerName | String | | 고객명 | "김민수" |
| orderDate | String | ✓ | 주문일 | "2024-09-14" |
| orderType | String | ✓ | 주문 유형 | PICKUP, DINE_IN |
| status | String | ✓ | 주문 상태 | PAYMENT_COMPLETED, ORDER_RECEIVED, COOKING_COMPLETED, PICKUP_COMPLETED, CANCELLED |
| orderAmount | Int | ✓ | 주문 금액 | 15000 |
| totalAmount | String | ✓ | 총 금액 | "15000" |
| discountAmount | Int | | 할인 금액 | 1000 |
| deliveryFee | String | | 배달비 | "3000" |
| finalAmount | String | ✓ | 최종 결제 금액 | "17000" |
| paymentAmount | Int | ✓ | 결제 금액 | 17000 |
| paymentMethod | String | ✓ | 결제 방법 | CARD, CASH, MOBILE_PAY, POINT |
| paymentStatus | String | ✓ | 결제 상태 | PENDING, COMPLETED, FAILED, REFUNDED |
| items | List<OrderItem> | | 주문 항목 | [...] |
| menuItems | String | | 메뉴 간단 표시 | "김치찌개 외 2건" |
| deliveryAddress | String | | 배달 주소 | "서울시..." |
| customerPhone | String | | 고객 전화번호 | "010-1234-5678" |
| specialInstructions | String | | 특별 요청사항 | "덜 맵게" |
| completedDate | String | | 완료일 | "2024-09-14" |
| cancelledDate | String | | 취소일 | "2024-09-14" |
| cancelReason | String | | 취소 사유 | "..." |
| rating | Double | | 평점 | 4.5 |
| review | String | | 리뷰 | "맛있어요" |
| paymentCompleteTime | String | | 결제완료 시간 | "14:30:00" |
| orderAcceptTime | String | | 주문접수 시간 | "14:31:00" |
| cookingCompleteTime | String | | 조리완료 시간 | "14:45:00" |
| pickupCompleteTime | String | | 픽업완료 시간 | "14:50:00" |

### 주문 항목 (OrderItem)
| 필드명 | 타입 | 필수 | 설명 |
|--------|------|------|------|
| id | String | ✓ | 고유 ID |
| menuId | String | ✓ | 메뉴 ID |
| menuName | String | ✓ | 메뉴명 |
| unitPrice | String | ✓ | 단가 |
| quantity | Int | ✓ | 수량 |
| totalPrice | String | ✓ | 총 가격 |
| options | List<OrderOption> | | 선택 옵션 |

---

## 6. 정산 관리 (Settlement)

### 테이블명: `settlements`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "ST001" |
| businessId | String | ✓ | 사업자 ID | "B001" |
| businessName | String | | 사업자명 | "맛있는식당" |
| storeId | String | ✓ | 매장 ID | "S001" |
| storeName | String | | 매장명 | "맛있는식당 강남점" |
| settlementDate | String | ✓ | 정산일 | "2024-09-15" |
| periodStart | String | ✓ | 정산 기간 시작 | "2024-09-01" |
| periodEnd | String | ✓ | 정산 기간 종료 | "2024-09-07" |
| totalSalesAmount | String | ✓ | 총 매출 금액 | "1250000" |
| platformFeeRate | String | ✓ | 플랫폼 수수료율(%) | "3.3" |
| platformFeeAmount | String | ✓ | 플랫폼 수수료 금액 | "41250" |
| deliveryFeeAmount | String | ✓ | 배달비 수수료 | "12500" |
| discountAmount | String | | 할인 금액 | "0" |
| refundAmount | String | | 환불 금액 | "0" |
| adjustmentAmount | String | ✓ | 조정 금액 | "0" |
| settlementAmount | String | ✓ | 최종 정산 금액 | "1196250" |
| status | String | ✓ | 정산 상태 | PENDING, CONFIRMED, PAID, CANCELLED |
| accountNumber | String | | 정산 계좌번호 | "1234567890" |
| accountHolder | String | | 예금주 | "김사장" |
| bankName | String | | 은행명 | "국민은행" |
| paymentDate | String | | 지급일 | "2024-09-22" |
| notes | String | | 비고 | "..." |
| totalOrders | Int | ✓ | 총 주문 수 | 150 |
| completedOrders | Int | ✓ | 완료된 주문 수 | 145 |
| cancelledOrders | Int | ✓ | 취소된 주문 수 | 5 |
| createdDate | String | | 생성일 | "2024-09-14" |
| lastModifiedDate | String | | 최종 수정일 | "2024-09-15" |

---

## 7. 리뷰 관리 (Review)

### 테이블명: `reviews`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "R001" |
| customerId | String | ✓ | 고객 ID | "M001" |
| customerName | String | ✓ | 고객명 | "김민수" |
| customerNickname | String | ✓ | 고객 닉네임 | "맛집러버" |
| storeId | String | ✓ | 매장 ID | "S001" |
| storeName | String | ✓ | 매장명 | "맛있는식당" |
| orderId | String | ✓ | 주문 ID | "O001" |
| orderMenu | String | ✓ | 주문 메뉴 | "김치찌개" |
| rating | Int | ✓ | 평점 (1-5) | 5 |
| content | String | ✓ | 리뷰 내용 | "정말 맛있어요!" |
| createdAt | String | ✓ | 작성일 | "2024-09-14" |
| imageUrls | List<String> | | 리뷰 이미지 URL | ["https://...", ...] |
| storeReply | String | | 매장 답글 | "감사합니다!" |
| storeReplyDate | String | | 매장 답글 작성일 | "2024-09-15" |

---

## 8. 관리자 관리 (Admin)

### 테이블명: `admins`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "A001" |
| adminId | String | ✓ | 관리자 로그인 ID | "admin001" |
| name | String | ✓ | 이름 | "김관리자" |
| email | String | ✓ | 이메일 | "admin@yumyum.com" |
| phone | String | ✓ | 전화번호 | "010-1234-5678" |
| department | String | ✓ | 부서 | "운영팀" |
| position | String | ✓ | 직책 | "팀장" |
| role | String | ✓ | 권한 | SUPER_ADMIN, ADMIN, MANAGER, STAFF |
| createdAt | DateTime | ✓ | 생성일 | "2024-01-01T00:00:00Z" |
| lastLoginAt | DateTime | | 최근 로그인 | "2024-09-14T10:30:00Z" |
| status | String | ✓ | 상태 | ACTIVE, INACTIVE, SUSPENDED |
| profileImage | String | | 프로필 이미지 | "https://..." |

---

## 9. 닉네임 관리 (Nickname)

### 테이블명: `nicknames`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "N001" |
| userId | String | ✓ | 사용자 ID | "M001" |
| nickname | String | ✓ | 닉네임 | "맛집러버" |
| status | String | ✓ | 상태 | ACTIVE, INACTIVE, BANNED |
| createdAt | String | ✓ | 생성일 | "2024-09-01" |
| modifiedAt | String | | 수정일 | "2024-09-10" |

### 금지어 테이블명: `banned_words`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "BW001" |
| word | String | ✓ | 금지어 | "비속어" |
| severity | String | ✓ | 심각도 | HIGH, MEDIUM, LOW |
| createdAt | String | ✓ | 등록일 | "2024-01-01" |

---

## 10. 승인 요청 관리 (Approval)

### 테이블명: `approval_requests`

| 필드명 | 타입 | 필수 | 설명 | 예시값 |
|--------|------|------|------|--------|
| id | String | ✓ | 고유 ID | "AR001" |
| requestType | String | ✓ | 요청 유형 | BUSINESS_REGISTRATION, MENU_CHANGE |
| businessId | String | | 사업자 ID | "B001" |
| storeId | String | | 매장 ID | "S001" |
| requesterId | String | ✓ | 요청자 ID | "B001" |
| requesterName | String | ✓ | 요청자명 | "김사장" |
| status | String | ✓ | 상태 | PENDING, APPROVED, REJECTED |
| requestDate | String | ✓ | 요청일 | "2024-09-14" |
| processDate | String | | 처리일 | "2024-09-15" |
| processedBy | String | | 처리자 ID | "A001" |
| reason | String | | 거부 사유 | "..." |
| attachments | List<String> | | 첨부파일 URL | ["https://...", ...] |

---

## API 엔드포인트 참고

### 회원 관리
- `GET /api/members` - 회원 목록 조회
- `GET /api/members/{id}` - 회원 상세 조회
- `POST /api/members` - 회원 등록
- `PUT /api/members/{id}` - 회원 정보 수정
- `DELETE /api/members/{id}` - 회원 삭제

### 사업자 관리
- `GET /api/businesses` - 사업자 목록 조회
- `GET /api/businesses/{id}` - 사업자 상세 조회
- `POST /api/businesses` - 사업자 등록
- `PUT /api/businesses/{id}` - 사업자 정보 수정
- `PUT /api/businesses/{id}/status` - 승인 상태 변경

### 매장 관리
- `GET /api/stores` - 매장 목록 조회
- `GET /api/stores/{id}` - 매장 상세 조회
- `POST /api/stores` - 매장 등록
- `PUT /api/stores/{id}` - 매장 정보 수정

### 주문 관리
- `GET /api/orders` - 주문 목록 조회
- `GET /api/orders/{id}` - 주문 상세 조회
- `PUT /api/orders/{id}/status` - 주문 상태 변경

### 정산 관리
- `GET /api/settlements` - 정산 목록 조회
- `GET /api/settlements/{id}` - 정산 상세 조회
- `POST /api/settlements` - 정산 생성
- `PUT /api/settlements/{id}/status` - 정산 상태 변경

---

## 상태 코드 (Status Codes)

### 회원 상태
- `ACTIVE` - 활성
- `INACTIVE` - 비활성
- `SUSPENDED` - 정지
- `WITHDRAWN` - 탈퇴

### 사업자/승인 상태
- `PENDING` - 대기
- `APPROVED` - 승인
- `REJECTED` - 거부

### 매장 상태
- `OPEN` - 영업중
- `CLOSED` - 휴업
- `OUT_OF_BUSINESS` - 폐업

### 주문 상태
- `PAYMENT_COMPLETED` - 결제완료
- `ORDER_RECEIVED` - 주문접수
- `COOKING_COMPLETED` - 조리완료
- `PICKUP_COMPLETED` - 픽업완료
- `CANCELLED` - 취소

### 결제 상태
- `PENDING` - 대기
- `COMPLETED` - 완료
- `FAILED` - 실패
- `REFUNDED` - 환불

### 정산 상태
- `PENDING` - 대기
- `CONFIRMED` - 확정
- `PAID` - 지급완료
- `CANCELLED` - 취소

### 메뉴 상태
- `SELLING` - 판매중
- `SOLD_OUT` - 오늘만 품절
- `HIDDEN` - 메뉴 숨김

---

생성일: 2024-10-20
버전: 1.0.0

