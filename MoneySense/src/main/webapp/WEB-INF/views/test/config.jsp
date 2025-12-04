<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>오픈뱅킹 설정 확인 - MoneySense</title>
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
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        h1 {
            color: #007bff;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #007bff;
        }
        .test-result {
            margin: 20px 0;
        }
        .test-item {
            display: flex;
            justify-content: space-between;
            padding: 15px;
            margin: 10px 0;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .test-label {
            font-weight: bold;
            color: #495057;
        }
        .test-value {
            color: #212529;
            word-break: break-all;
            max-width: 60%;
            text-align: right;
        }
        .success {
            border-left-color: #28a745;
        }
        .error {
            border-left-color: #dc3545;
        }
        .status-success {
            color: #28a745;
            font-weight: bold;
        }
        .status-error {
            color: #dc3545;
            font-weight: bold;
        }
        .info-box {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
            padding: 15px;
            border-radius: 5px;
            margin-top: 30px;
        }
        .info-box h3 {
            margin-bottom: 10px;
        }
        .back-button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .back-button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>오픈뱅킹 설정 확인</h1>
        
        <div class="test-result">
            <h2>설정 값 확인</h2>
            
            <div class="test-item ${not empty clientId ? 'success' : 'error'}">
                <span class="test-label">Client ID:</span>
                <span class="test-value">
                    <c:choose>
                        <c:when test="${not empty clientId}">
                            ${clientId}
                        </c:when>
                        <c:otherwise>
                            <span class="status-error">설정되지 않음</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="test-item ${not empty clientSecret ? 'success' : 'error'}">
                <span class="test-label">Client Secret:</span>
                <span class="test-value">
                    <c:choose>
                        <c:when test="${not empty clientSecret}">
                            ${clientSecret}
                        </c:when>
                        <c:otherwise>
                            <span class="status-error">설정되지 않음</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="test-item ${not empty redirectUri ? 'success' : 'error'}">
                <span class="test-label">Redirect URI:</span>
                <span class="test-value">
                    <c:choose>
                        <c:when test="${not empty redirectUri}">
                            ${redirectUri}
                        </c:when>
                        <c:otherwise>
                            <span class="status-error">설정되지 않음</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="test-item ${not empty baseUrl ? 'success' : 'error'}">
                <span class="test-label">Base URL:</span>
                <span class="test-value">
                    <c:choose>
                        <c:when test="${not empty baseUrl}">
                            ${baseUrl}
                        </c:when>
                        <c:otherwise>
                            <span class="status-error">설정되지 않음</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="test-item ${not empty grantType ? 'success' : 'error'}">
                <span class="test-label">Grant Type:</span>
                <span class="test-value">
                    <c:choose>
                        <c:when test="${not empty grantType}">
                            ${grantType}
                        </c:when>
                        <c:otherwise>
                            <span class="status-error">설정되지 않음</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="test-item ${apiClientStatus == '주입 성공' ? 'success' : 'error'}">
                <span class="test-label">API Client 빈 주입:</span>
                <span class="test-value">
                    <c:choose>
                        <c:when test="${apiClientStatus == '주입 성공'}">
                            <span class="status-success">${apiClientStatus}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-error">${apiClientStatus}</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
        
        <div class="info-box">
            <h3>확인 사항</h3>
            <ul>
                <li>모든 항목이 <strong style="color: #28a745;">성공</strong>으로 표시되어야 합니다.</li>
                <li>Client ID와 Client Secret은 금융결제원에서 발급받은 값이어야 합니다.</li>
                <li>Redirect URI는 금융결제원에 등록한 주소와 일치해야 합니다.</li>
                <li>API Client 빈 주입이 성공해야 다음 단계로 진행 가능합니다.</li>
            </ul>
        </div>
        
        <a href="${pageContext.request.contextPath}/main" class="back-button">메인으로 돌아가기</a>
    </div>
</body>
</html>