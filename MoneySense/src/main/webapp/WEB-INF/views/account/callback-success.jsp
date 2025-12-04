<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>계좌 연동 완료 - MoneySense</title>
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
        .success-icon {
            font-size: 60px;
            color: #28a745;
            margin-bottom: 20px;
        }
        h1 {
            color: #28a745;
            margin-bottom: 20px;
        }
        .token-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: left;
        }
        .token-item {
            margin: 10px 0;
            padding: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        .token-item:last-child {
            border-bottom: none;
        }
        .token-label {
            font-weight: bold;
            color: #495057;
            display: inline-block;
            width: 150px;
        }
        .btn-dashboard {
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
        .btn-dashboard:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">✓</div>
        <h1>계좌 연동 완료!</h1>
        <p>${msg}</p>
        
        <div class="token-info">
            <h3>연동 정보</h3>
            <div class="token-item">
                <span class="token-label">사용자 번호:</span>
                <span>${tokenInfo.user_seq_no}</span>
            </div>
            <div class="token-item">
                <span class="token-label">토큰 타입:</span>
                <span>${tokenInfo.token_type}</span>
            </div>
            <div class="token-item">
                <span class="token-label">유효 기간:</span>
                <span>${tokenInfo.expires_in}초</span>
            </div>
            <div class="token-item">
                <span class="token-label">권한 범위:</span>
                <span>${tokenInfo.scope}</span>
            </div>
        </div>
        
        <a href="${pageContext.request.contextPath}/dashboard" class="btn-dashboard">
            대시보드로 이동
        </a>
    </div>
</body>
</html>