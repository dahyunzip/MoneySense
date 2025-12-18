<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../include/Header.jsp"%>

<style>
.ai-insights-page {width:100%; max-width:1200px; margin:0 auto; padding:20px;}
.ai-insights-page .insights-header {background:#fff; padding:20px; border-radius:8px; margin-bottom:20px;}
.ai-insights-page .insights-header h2 {margin:0 0 10px 0; font-size:24px; color:#333;}
.ai-insights-page .insights-header p {margin:0; color:#666; font-size:14px;}
.ai-insights-page .insights-actions {display:flex; gap:10px; margin-bottom:20px;}
.ai-insights-page .insights-actions button {padding:12px 24px; background:#00AEEE; color:#fff; border:none; border-radius:8px; cursor:pointer; font-size:14px; font-weight:500; transition:all 0.2s;}
.ai-insights-page .insights-actions button:hover {background:#0099d4;}
.ai-insights-page .insights-actions button:disabled {background:#ccc; cursor:not-allowed;}
.ai-insights-page .insights-actions select {padding:12px; border:1px solid #ddd; border-radius:8px; font-size:14px; cursor:pointer;}
.ai-insights-page .insights-grid {display:grid; grid-template-columns:repeat(auto-fill, minmax(350px, 1fr)); gap:20px;}
.ai-insights-page .insight-card {background:#fff; border-radius:8px; padding:20px; border:1px solid #e5e5e5; transition:all 0.2s;}
.ai-insights-page .insight-card .card-header {display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; padding-bottom:15px; border-bottom:2px solid #f0f0f0;}
.ai-insights-page .insight-card .card-type {display:inline-block; padding:4px 12px; background:#e3f2fd; color:#1976d2; border-radius:4px; font-size:12px; font-weight:500;}
.ai-insights-page .insight-card .card-type.monthly {background:#e8f5e9; color:#388e3c;}
.ai-insights-page .insight-card .card-type.category {background:#fff3e0; color:#f57c00;}
.ai-insights-page .insight-card .card-period {font-size:13px; color:#999;}
.ai-insights-page .insight-card .card-body {margin-bottom:15px;}
.ai-insights-page .insight-card .amount-info {display:flex; justify-content:space-between; margin-bottom:10px;}
.ai-insights-page .insight-card .amount-label {font-size:13px; color:#666;}
.ai-insights-page .insight-card .amount-value {font-size:16px; font-weight:600; color:#333;}
.ai-insights-page .insight-card .amount-value.positive {color:#388e3c;}
.ai-insights-page .insight-card .amount-value.negative {color:#d32f2f;}
.ai-insights-page .insight-card .change-rate {display:inline-flex; align-items:center; gap:4px; padding:4px 8px; border-radius:4px; font-size:13px; font-weight:500;}
.ai-insights-page .insight-card .change-rate.up {background:#ffebee; color:#d32f2f;}
.ai-insights-page .insight-card .change-rate.down {background:#e8f5e9; color:#388e3c;}
.ai-insights-page .insight-card .summary {font-size:14px; line-height:1.6; color:#555; padding:15px; background:#f8f9fa; border-radius:6px; border-left:3px solid #00AEEE;}
.ai-insights-page .insight-card .card-footer {padding-top:15px; border-top:1px solid #f0f0f0; font-size:12px; color:#999;}
.ai-insights-page .empty-insights {text-align:center; padding:60px 20px; background:#fff; border-radius:8px; box-shadow:0 2px 4px rgba(0,0,0,0.1);}
.ai-insights-page .empty-insights-icon {font-size:48px; margin-bottom:15px; opacity:0.5;}
.ai-insights-page .empty-insights-text {font-size:16px; color:#666; margin-bottom:10px;}
.ai-insights-page .empty-insights-subtext {font-size:14px; color:#999;}
.ai-insights-page .loading-spinner {text-align:center; padding:40px;}
.ai-insights-page .loading-spinner .spinner {width:40px; height:40px; margin:0 auto; border:4px solid #f3f3f3; border-top:4px solid #00AEEE; border-radius:50%; animation:spin 1s linear infinite;}
@keyframes spin {0% {transform:rotate(0deg);} 100% {transform:rotate(360deg);}}
</style>

<div id="subContents">
    <div class="fix-layout ai-insights-page">
        <!-- 헤더 -->
        <div class="insights-header">
            <h1 class="page-title mb20">📊 AI 소비 인사이트</h1>
            <p class="page-sub-title">AI가 분석한 나의 소비 패턴을 확인해보세요</p>
        </div>
        
        <!-- 액션 버튼 -->
        <div class="insights-actions">
            <select id="categorySelect">
			    <option value="">카테고리 선택</option>
			    <option value="1">식비</option>
			    <option value="2">교육</option>
			    <option value="3">쇼핑</option>
			    <option value="4">문화</option>
			    <option value="5">의료/건강</option>
			    <option value="6">교통</option>
			    <option value="7">주거/통신</option>
			    <option value="8">주거</option>
			    <option value="9">통신</option>
			    <option value="10">기타</option>
			</select>
            <button id="generateMonthlyBtn" type="button">이번 달 인사이트 생성</button>
            <button id="generateCategoryBtn" type="button">카테고리 인사이트 생성</button>
        </div>
        
        <!-- 인사이트 목록 -->
        <div class="insights-grid" id="insightsGrid">
            <c:choose>
                <c:when test="${not empty insights}">
                    <c:forEach var="insight" items="${insights}">
                        <div class="insight-card">
                            <div class="card-header">
                                <span class="card-type ${insight.insightType == 'MONTHLY' ? 'monthly' : 'category'}">
                                    ${insight.insightType == 'MONTHLY' ? '월간 분석' : '카테고리 분석'}
                                </span>
                                <span class="card-period">
                                    ${insight.period}
                                    <c:if test="${not empty insight.categoryName}">
								         - ${insight.categoryName}
								    </c:if>
                                </span>
                            </div>
                            
                            <div class="card-body">
                                <div class="amount-info">
                                    <div>
                                        <div class="amount-label">현재 지출</div>
                                        <div class="amount-value">
                                            <fmt:formatNumber value="${insight.currentAmount}" pattern="#,###"/>원
                                        </div>
                                    </div>
                                    <c:if test="${not empty insight.previousAmount}">
                                        <div>
                                            <div class="amount-label">이전 지출</div>
                                            <div class="amount-value">
                                                <fmt:formatNumber value="${insight.previousAmount}" pattern="#,###"/>원
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <c:if test="${not empty insight.changeRate}">
                                    <div style="margin-bottom:15px;">
                                        <span class="change-rate ${insight.changeRate > 0 ? 'up' : 'down'}">
                                            ${insight.changeRate > 0 ? '↑' : '↓'}
                                            <fmt:formatNumber value="${insight.changeRate}" pattern="#,##0.00"/>%
                                        </span>
                                    </div>
                                </c:if>
                                
                                <div class="summary">
                                    ${insight.summary}
                                </div>
                            </div>
                            
                            <div class="card-footer">
                                <fmt:formatDate value="${insight.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-insights">
                        <div class="empty-insights-icon">📊</div>
                        <div class="empty-insights-text">아직 생성된 인사이트가 없습니다</div>
                        <div class="empty-insights-subtext">위의 버튼을 눌러 AI 분석을 시작해보세요!</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    
    const csrfToken = '${_csrf.token}';
    const csrfHeader = '${_csrf.headerName}';
    
    // 로딩 스피너 표시
    function showLoading() {
        const loadingHtml = 
            '<div class="loading-spinner">' +
                '<div class="spinner"></div>' +
                '<p style="margin-top:15px; color:#666;">AI가 분석 중입니다...</p>' +
            '</div>';
        
        $('#insightsGrid').html(loadingHtml);
    }
    
    // 인사이트 카드 생성
    function createInsightCard(insight) {
        const typeClass = insight.insightType === 'MONTHLY' ? 'monthly' : 'category';
        const typeText = insight.insightType === 'MONTHLY' ? '월간 분석' : '카테고리 분석';
        const changeClass = insight.changeRate > 0 ? 'up' : 'down';
        const changeIcon = insight.changeRate > 0 ? '↑' : '↓';
        
        let html = '<div class="insight-card">';
        html += '<div class="card-header">';
        html += '<span class="card-type ' + typeClass + '">' + typeText + '</span>';
        html += '<span class="card-period">' + insight.period;
        if (insight.category) {
            html += ' - ' + insight.category;
        }
        html += '</span></div>';
        
        html += '<div class="card-body">';
        html += '<div class="amount-info">';
        html += '<div><div class="amount-label">현재 지출</div>';
        html += '<div class="amount-value">' + insight.currentAmount.toLocaleString() + '원</div></div>';
        
        if (insight.previousAmount) {
            html += '<div><div class="amount-label">이전 지출</div>';
            html += '<div class="amount-value">' + insight.previousAmount.toLocaleString() + '원</div></div>';
        }
        html += '</div>';
        
        if (insight.changeRate != null) {
            html += '<div style="margin-bottom:15px;">';
            html += '<span class="change-rate ' + changeClass + '">';
            html += changeIcon + ' ' + Math.abs(insight.changeRate).toFixed(2) + '%';
            html += '</span></div>';
        }
        
        html += '<div class="summary">' + insight.summary + '</div>';
        html += '</div>';
        
        html += '<div class="card-footer">' + new Date(insight.createdAt).toLocaleString('ko-KR') + '</div>';
        html += '</div>';
        
        return html;
    }
    
    // 인사이트 목록 로드
    function loadInsights() {
        $.ajax({
            url: '${ctx}/ai/insights/list',
            type: 'GET',
            data: {
                limit: 10
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(response) {
                if (response.success && response.insights.length > 0) {
                    let html = '';
                    response.insights.forEach(function(insight) {
                        html += createInsightCard(insight);
                    });
                    $('#insightsGrid').html(html);
                } else {
                    const emptyHtml = 
                        '<div class="empty-insights">' +
                            '<div class="empty-insights-icon">📊</div>' +
                            '<div class="empty-insights-text">아직 생성된 인사이트가 없습니다</div>' +
                            '<div class="empty-insights-subtext">위의 버튼을 눌러 AI 분석을 시작해보세요!</div>' +
                        '</div>';
                    $('#insightsGrid').html(emptyHtml);
                }
            },
            error: function(xhr, status, error) {
                console.error('인사이트 로드 오류:', error);
                alert('인사이트를 불러오는 중 오류가 발생했습니다.');
            }
        });
    }
    
    // 월간 인사이트 생성
    $('#generateMonthlyBtn').click(function() {
        const btn = $(this);
        btn.prop('disabled', true).text('생성 중...');
        
        showLoading();
        
        $.ajax({
            url: '${ctx}/ai/insights/monthly',
            type: 'POST',
            data: {
                year: 0,
                month: 0
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(response) {
                if (response.success) {
                    alert('월간 인사이트가 생성되었습니다!');
                    loadInsights();
                } else {
                    alert('인사이트 생성 중 오류가 발생했습니다.');
                }
            },
            error: function(xhr, status, error) {
                console.error('인사이트 생성 오류:', error);
                alert('인사이트 생성 중 오류가 발생했습니다.');
                loadInsights();
            },
            complete: function() {
                btn.prop('disabled', false).text('이번 달 인사이트 생성');
            }
        });
    });
    
    // 카테고리 인사이트 생성
    $('#generateCategoryBtn').click(function() {
        const categoryId = $('#categorySelect').val();
        
        if (!categoryId) { 
            alert('카테고리를 선택해주세요.');
            return;
        }
        
        const btn = $(this);
        btn.prop('disabled', true).text('생성 중...');
        
        showLoading();
        
        $.ajax({
            url: '${ctx}/ai/insights/category',
            type: 'POST',
            data: {
                categoryId: categoryId,
                year: 0,
                month: 0
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(response) {
                if (response.success) {
                	const categoryText = $('#categorySelect option:selected').text();
                	alert(categoryText + ' 인사이트가 생성되었습니다!');
                    loadInsights();
                } else {
                    alert('인사이트 생성 중 오류가 발생했습니다.');
                }
            },
            error: function(xhr, status, error) {
                console.error('인사이트 생성 오류:', error);
                alert('인사이트 생성 중 오류가 발생했습니다.');
                loadInsights();
            },
            complete: function() {
                btn.prop('disabled', false).text('카테고리 인사이트 생성');
            }
        });
    });
    
});
</script>
<%@ include file="../include/Fixed.jsp"%>