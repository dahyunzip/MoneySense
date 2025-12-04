<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>계좌 연동 - MoneySense</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
        }
        h1 {
            color: #007bff;
            margin-bottom: 20px;
        }
        .info-box {
            background: #e7f3ff;
            border: 1px solid #b3d9ff;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: left;
        }
        .info-box h3 {
            color: #004085;
            margin-bottom: 10px;
        }
        .info-box ul {
            margin-left: 20px;
            color: #004085;
        }
        .btn-connect {
            display: inline-block;
            padding: 15px 30px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            margin-top: 20px;
            transition: background 0.3s;
        }
        .btn-connect:hover {
            background: #0056b3;
        }
        .btn-back {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .btn-back:hover {
            background: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>오픈뱅킹 계좌 연동</h1>
        
        <div class="info-box">
            <h3>연동 안내</h3>
            <ul>
                <li>금융결제원 오픈뱅킹 서비스를 통해 안전하게 연동됩니다.</li>
                <li>계좌 정보는 암호화되어 저장됩니다.</li>
                <li>언제든지 연동을 해제할 수 있습니다.</li>
                <li>자동으로 거래내역이 가계부에 반영됩니다.</li>
            </ul>
        </div>
        
        <!-- 
            실제 오픈뱅킹 인증 URL로 이동
            금융결제원 테스트 환경 주소 예시
        -->
        <a href="https://testapi.openbanking.or.kr/oauth/2.0/authorize?response_type=code&client_id=669dcc6e-ac4a-42a8-8910-85d7c1485911&redirect_uri=http://localhost:8088/accounts/callback&scope=login inquiry transfer&state=12345678901234567890123456789012&auth_type=0" 
           class="btn-connect">
            계좌 연동하기
        </a>
        
        <br>
        
        <a href="${pageContext.request.contextPath}/main" class="btn-back">나중에 하기</a>
    </div>
</body>
</html>