<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - MoneySense</title>
    <!-- jQuery CDN -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
        }
        
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        
        input[type="email"],
        input[type="password"],
        input[type="text"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        input.valid {
            border-color: #28a745;
        }
        
        input.invalid {
            border-color: #dc3545;
        }
        
        .email-check {
            display: flex;
            gap: 10px;
        }
        
        .email-check input {
            flex: 1;
        }
        
        .btn-check {
            padding: 12px 20px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            white-space: nowrap;
        }
        
        .btn-check:hover {
            background: #5a6268;
        }
        
        .message {
            font-size: 12px;
            margin-top: 5px;
        }
        
        .message.success {
            color: #28a745;
        }
        
        .message.error {
            color: #dc3545;
        }
        
        .message.info {
            color: #17a2b8;
        }
        
        .password-strength {
            margin-top: 10px;
            padding: 10px;
            border-radius: 5px;
            font-size: 12px;
            display: none;
        }
        
        .password-strength.weak {
            background: #f8d7da;
            color: #721c24;
            display: block;
        }
        
        .password-strength.medium {
            background: #fff3cd;
            color: #856404;
            display: block;
        }
        
        .password-strength.strong {
            background: #d4edda;
            color: #155724;
            display: block;
        }
        
        .password-requirements {
            margin-top: 8px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 5px;
            font-size: 12px;
        }
        
        .password-requirements ul {
            margin: 5px 0;
            padding-left: 20px;
        }
        
        .password-requirements li {
            margin: 3px 0;
            color: #6c757d;
        }
        
        .password-requirements li.valid {
            color: #28a745;
        }
        
        .password-requirements li.invalid {
            color: #dc3545;
        }
        
        .checkbox-group {
            margin: 20px 0;
        }
        
        .checkbox-group label {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            font-weight: normal;
            cursor: pointer;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin-right: 8px;
        }
        
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
        }
        
        .btn-submit:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>💰 MoneySense</h2>
        
        <c:if test="${not empty msg}">
            <div class="alert alert-danger">${msg}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/members/signup" method="post" id="signupForm">
            <!-- CSRF 토큰 -->
            <sec:csrfInput/>
            
            <div class="form-group">
                <label for="email">이메일 *</label>
                <div class="email-check">
                    <input type="email" id="email" name="email" required placeholder="example@email.com">
                    <button type="button" class="btn-check" id="btnCheckEmail">중복확인</button>
                </div>
                <div id="emailMsg" class="message"></div>
            </div>
            
            <div class="form-group">
                <label for="password">비밀번호 *</label>
                <input type="password" id="password" name="password" required 
                       placeholder="8~20자, 영문 대소문자, 숫자, 특수문자 포함">
                <div class="password-requirements">
                    <strong>비밀번호 요구사항:</strong>
                    <ul>
                        <li id="req-length">8~20자</li>
                        <li id="req-lower">영문 소문자 포함</li>
                        <li id="req-upper">영문 대문자 포함</li>
                        <li id="req-number">숫자 포함</li>
                        <li id="req-special">특수문자 포함 (!@#$%^&amp;*)</li>
                    </ul>
                </div>
                <div id="passwordStrength" class="password-strength"></div>
            </div>
            
            <div class="form-group">
                <label for="passwordConfirm">비밀번호 확인 *</label>
                <input type="password" id="passwordConfirm" required 
                       placeholder="비밀번호를 다시 입력해주세요">
                <div id="pwMsg" class="message"></div>
            </div>
            
            <div class="form-group">
                <label for="name">이름 *</label>
                <input type="text" id="name" name="name" required placeholder="홍길동">
            </div>
            
            <div class="checkbox-group">
                <label>
                    <input type="checkbox" name="agreePrivacy" value="1" required>
                    개인정보 수집 및 이용에 동의합니다 (필수)
                </label>
                <label>
                    <input type="checkbox" name="agreeOpenbank" value="1" required>
                    오픈뱅킹 이용약관에 동의합니다 (필수)
                </label>
            </div>
            
            <button type="submit" class="btn-submit" id="submitBtn" disabled>회원가입</button>
        </form>
        
        <div class="login-link">
            이미 계정이 있으신가요? <a href="${pageContext.request.contextPath}/members/login">로그인</a>
        </div>
    </div>
    
    <script>
        $(document).ready(function() {
            let emailChecked = false;
            let passwordValid = false;
            
            // 이메일 입력시 중복체크 초기화
            $('#email').on('input', function() {
                emailChecked = false;
                $('#emailMsg').text('');
                checkFormValid();
            });
            
            // 이메일 중복 체크
            $('#btnCheckEmail').on('click', function() {
                const email = $('#email').val().trim();
                
                if (!email) {
                    $('#emailMsg').removeClass('success').addClass('error').text('이메일을 입력해주세요.');
                    return;
                }
                
                // 이메일 형식 검증
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    $('#emailMsg').removeClass('success').addClass('error').text('올바른 이메일 형식이 아닙니다.');
                    return;
                }
                
                // AJAX 요청 (RESTful URL)
                $.ajax({
                    url: '${pageContext.request.contextPath}/members/check-email',
                    type: 'GET',
                    data: { email: email },
                    success: function(response) {
                        if (response === 'duplicate') {
                            $('#emailMsg').removeClass('success').addClass('error').text('이미 사용중인 이메일입니다.');
                            $('#email').removeClass('valid').addClass('invalid');
                            emailChecked = false;
                        } else {
                            $('#emailMsg').removeClass('error').addClass('success').text('사용 가능한 이메일입니다.');
                            $('#email').removeClass('invalid').addClass('valid');
                            emailChecked = true;
                        }
                        checkFormValid();
                    },
                    error: function() {
                        $('#emailMsg').removeClass('success').addClass('error').text('중복 확인에 실패했습니다.');
                        emailChecked = false;
                        checkFormValid();
                    }
                });
            });
            
            // 비밀번호 유효성 검사
            $('#password').on('input', function() {
                const password = $(this).val();
                validatePassword(password);
                
                // 비밀번호 확인란이 입력된 경우 재검사
                if ($('#passwordConfirm').val()) {
                    checkPasswordMatch();
                }
                
                checkFormValid();
            });
            
            // 비밀번호 확인
            $('#passwordConfirm').on('input', function() {
                checkPasswordMatch();
                checkFormValid();
            });
            
            // 비밀번호 유효성 검사 함수
            function validatePassword(password) {
                // 요구사항 체크
                const hasLength = password.length >= 8 && password.length <= 20;
                const hasLower = /[a-z]/.test(password);
                const hasUpper = /[A-Z]/.test(password);
                const hasNumber = /[0-9]/.test(password);
                const hasSpecial = /[!@#$%^&*]/.test(password);
                
                // UI 업데이트
                updateRequirement('#req-length', hasLength);
                updateRequirement('#req-lower', hasLower);
                updateRequirement('#req-upper', hasUpper);
                updateRequirement('#req-number', hasNumber);
                updateRequirement('#req-special', hasSpecial);
                
                // 비밀번호 강도 계산
                const validCount = [hasLength, hasLower, hasUpper, hasNumber, hasSpecial].filter(Boolean).length;
                passwordValid = validCount === 5;
                
                // 비밀번호 강도 표시
                const $strength = $('#passwordStrength');
                if (password.length === 0) {
                    $strength.hide().removeClass('weak medium strong');
                    $('#password').removeClass('valid invalid');
                } else if (validCount < 3) {
                    $strength.removeClass('medium strong').addClass('weak').text('약함: 모든 조건을 충족해주세요.').show();
                    $('#password').removeClass('valid').addClass('invalid');
                } else if (validCount < 5) {
                    $strength.removeClass('weak strong').addClass('medium').text('보통: 모든 조건을 충족하면 안전합니다.').show();
                    $('#password').removeClass('valid').addClass('invalid');
                } else {
                    $strength.removeClass('weak medium').addClass('strong').text('강함: 안전한 비밀번호입니다.').show();
                    $('#password').removeClass('invalid').addClass('valid');
                }
            }
            
            // 요구사항 UI 업데이트
            function updateRequirement(selector, isValid) {
                if (isValid) {
                    $(selector).removeClass('invalid').addClass('valid').html('✓ ' + $(selector).text().replace('✓ ', '').replace('✗ ', ''));
                } else {
                    $(selector).removeClass('valid').addClass('invalid').html('✗ ' + $(selector).text().replace('✓ ', '').replace('✗ ', ''));
                }
            }
            
            // 비밀번호 일치 확인
            function checkPasswordMatch() {
                const password = $('#password').val();
                const passwordConfirm = $('#passwordConfirm').val();
                const $pwMsg = $('#pwMsg');
                
                if (passwordConfirm === '') {
                    $pwMsg.text('');
                    $('#passwordConfirm').removeClass('valid invalid');
                } else if (password !== passwordConfirm) {
                    $pwMsg.removeClass('success').addClass('error').text('비밀번호가 일치하지 않습니다.');
                    $('#passwordConfirm').removeClass('valid').addClass('invalid');
                } else {
                    $pwMsg.removeClass('error').addClass('success').text('비밀번호가 일치합니다.');
                    $('#passwordConfirm').removeClass('invalid').addClass('valid');
                }
            }
            
            // 전체 폼 유효성 검사
            function checkFormValid() {
                const email = $('#email').val().trim();
                const password = $('#password').val();
                const passwordConfirm = $('#passwordConfirm').val();
                const name = $('#name').val().trim();
                const agreePrivacy = $('input[name="agreePrivacy"]').is(':checked');
                const agreeOpenbank = $('input[name="agreeOpenbank"]').is(':checked');
                
                const isValid = emailChecked && 
                               passwordValid && 
                               password === passwordConfirm && 
                               name && 
                               agreePrivacy && 
                               agreeOpenbank;
                
                $('#submitBtn').prop('disabled', !isValid);
            }
            
            // 모든 입력 필드 변경 감지
            $('#name, input[type="checkbox"]').on('input change', function() {
                checkFormValid();
            });
            
            // 폼 제출 전 최종 검증
            $('#signupForm').on('submit', function(e) {
                if (!emailChecked) {
                    e.preventDefault();
                    alert('이메일 중복확인을 해주세요.');
                    return false;
                }
                
                if (!passwordValid) {
                    e.preventDefault();
                    alert('비밀번호 요구사항을 모두 충족해주세요.');
                    return false;
                }
                
                const password = $('#password').val();
                const passwordConfirm = $('#passwordConfirm').val();
                
                if (password !== passwordConfirm) {
                    e.preventDefault();
                    alert('비밀번호가 일치하지 않습니다.');
                    return false;
                }
                
                return true;
            });
            
            // Enter 키로 폼 제출 방지 (중복확인 버튼 클릭 방지)
            $('#email').on('keypress', function(e) {
                if (e.which === 13) {
                    e.preventDefault();
                    $('#btnCheckEmail').click();
				}
			});
	});
</script>
</body>
</html>