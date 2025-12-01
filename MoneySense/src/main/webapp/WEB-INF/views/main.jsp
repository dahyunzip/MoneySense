<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인 - MoneySense</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 24px;
            font-weight: bold;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .btn-logout {
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            border: 1px solid white;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-logout:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .welcome {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        
        p {
            color: #666;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">💰 MoneySense</div>
            <div class="user-info">
                <span>
                    <sec:authentication property="principal.member.name"/>님 환영합니다!
                </span>
                <form action="${pageContext.request.contextPath}/members/logout" method="post" style="display: inline;">
                    <sec:csrfInput/>
                    <button type="submit" class="btn-logout">로그아웃</button>
                </form>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome">
            <h1>🎉 로그인 성공!</h1>
            <p>MoneySense에 오신 것을 환영합니다.</p>
            <p style="margin-top: 10px;">
                이메일: <strong><sec:authentication property="principal.username"/></strong>
            </p>
        </div>
    </div>
</body>
</html>