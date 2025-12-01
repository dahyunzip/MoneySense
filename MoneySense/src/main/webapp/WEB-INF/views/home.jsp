<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoneySense - 스마트한 가계부 관리</title>
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
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
            color: white;
        }
        
        .hero {
            text-align: center;
            max-width: 600px;
        }
        
        h1 {
            font-size: 48px;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .tagline {
            font-size: 20px;
            margin-bottom: 40px;
            opacity: 0.9;
        }
        
        .buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 15px 40px;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: white;
            color: #667eea;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        
        .btn-secondary {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 2px solid white;
        }
        
        .btn-secondary:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-3px);
        }
        
        .features {
            margin-top: 60px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 900px;
        }
        
        .feature {
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }
        
        .feature h3 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .feature p {
            opacity: 0.9;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="hero">
        <h1>💰 MoneySense</h1>
        <p class="tagline">AI가 함께하는 스마트한 가계부 관리</p>
        
        <div class="buttons">
            <a href="${pageContext.request.contextPath}/members/signup" class="btn btn-primary">
                무료로 시작하기
            </a>
            <a href="${pageContext.request.contextPath}/members/login" class="btn btn-secondary">
                로그인
            </a>
        </div>
    </div>
    
    <div class="features">
        <div class="feature">
            <h3>🏦 오픈뱅킹 연동</h3>
            <p>실시간으로 계좌 거래내역을 자동으로 불러옵니다</p>
        </div>
        <div class="feature">
            <h3>🤖 AI 소비 분석</h3>
            <p>OpenAI가 당신의 소비 패턴을 분석하고 조언합니다</p>
        </div>
        <div class="feature">
            <h3>📊 똑똑한 리포트</h3>
            <p>한눈에 보는 수입/지출 현황과 카테고리별 분석</p>
        </div>
    </div>
</body>
</html>