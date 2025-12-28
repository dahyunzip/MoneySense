<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="include/Header.jsp"%>
<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>

<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>
<style>
.main-container { background: #f8f9fa; min-height: 100vh; padding-bottom: 80px; }
.asset-summary { background: #fff; padding: 30px 20px; margin-top:20px; border-radius: 12px; }
.asset-title { font-size: 14px; color: #666; margin-bottom: 8px; display: flex; align-items: center; gap: 5px; font-weight:500; }
.asset-amount { font-size: 32px; font-weight: 700; color: #333; margin-bottom: 15px; }
.income-expense-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 15px; }
.ie-card { background: #f8f9fa; padding: 15px; border-radius: 12px; }
.ie-card-title { font-size: 13px; color: #666; margin-bottom: 5px; display: flex; align-items: center; gap: 5px; }
.ie-card-amount { font-size: 20px; font-weight: 700; color: #333; }
.ie-card-change { font-size: 12px; margin-top: 5px; }
.ie-card-change.up { color: #dc3545; }
.ie-card-change.down { color: #0066ff; }
.ie-card-comment span{font-size:10px; font-weight:600; color:#393939;margin-top:8px;}
.quick-menu {padding: 20px; margin-top: 20px; }
.quick-menu-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; text-align: center; }
.quick-menu-item { display: flex; flex-direction: column; align-items: center; gap: 8px; text-decoration: none; color: #333; }
.quick-menu-icon { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; background: #fff; transition:all .3s ease; transform:translateY(0) }
.quick-menu-item:hover .quick-menu-icon{ transition:all .3s ease; transform:translateY(-10px); box-shadow: 0 0 1px 5px rgb(214 214 214 / 10%)}
.quick-menu-item i{display:inline-block; width:30px; height:30px; }
.quick-menu-item .i01{background:url(/resources/images/ico_main01.svg) no-repeat; background-size:cover;}
.quick-menu-item .i02{background:url(/resources/images/ico_main02.svg) no-repeat; background-size:cover;}
.quick-menu-item .i03{background:url(/resources/images/ico_main03.svg) no-repeat; background-size:cover;}
.quick-menu-item .i04{background:url(/resources/images/ico_main04.svg) no-repeat; background-size:cover;}
.quick-menu-text { font-size: 12px; font-weight: 600; }
.chatbot-banner { padding: 20px; border-radius: 16px; margin: 20px 0; display: flex; align-items: center; gap: 15px; color: #000; }
.chatbot-icon { width: 50px; height: 50px; background: url(/resources/images/bot-icon.png) no-repeat center; background-size: 45px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 28px; }
.chatbot-text { font-size: 14px; font-weight: 400; background:#fff; width:100%; border-radius: 12px; padding:16px 12px;text-align:left; line-height:1.3; }
.category-section { background: #fff; padding: 20px; margin: 20px 0; border-radius: 12px; }
.section-title { font-size: 16px; font-weight: 700; color: #333; margin-bottom: 20px; }
.chart-container { position: relative; height: 250px; }
@media (max-width: 768px) { .asset-amount { font-size: 28px; } .quick-menu-grid { gap: 10px; } .quick-menu-icon { font-size: 20px; } }
</style>
<div id="mainContents" class="bgGray">
	<div class="fix-layout">
	    <!-- 자산 요약 -->
	    <div class="asset-summary">
	        <div class="asset-title">
	            나의 총 자산
	        </div>
	        <div class="asset-amount">
	            <fmt:formatNumber value="${totalAssets}" pattern="#,###"/>원
	        </div>
	        
	        <!-- 수입/지출 카드 -->
	        <div class="income-expense-grid">
	            <div class="ie-card">
	                <div class="ie-card-title">
	                    이번 달 지출
	                </div>
	                <div class="ie-card-amount">
	                    <fmt:formatNumber value="${monthlyExpense}" pattern="#,###"/>원
	                </div>
	                <c:if test="${expenseChange != null}">
	                    <div class="ie-card-change ${expenseChange > 0 ? 'up' : 'down'}">
	                        ${expenseChange > 0 ? '▲' : '▼'}
	                        <fmt:formatNumber value="${expenseChange}" pattern="#,###"/>원
	                    </div>
	                    <div class="ie-card-comment">
	                    	<c:if test="${expenseChange > 0}">
	                        	<span>😒?노력이 필요해요.</span>
	                        </c:if>
	                        <c:if test="${expenseChange < 0}">
	                        	<span>👍 잘 줄이고 있어요.</span>
	                        </c:if>
	                    </div>
	                </c:if>
	            </div>
	            
	            <div class="ie-card">
	                <div class="ie-card-title">
	                    이번 달 수입
	                </div>
	                <div class="ie-card-amount">
	                    <fmt:formatNumber value="${monthlyIncome}" pattern="#,###"/>원
	                </div>
	                <c:if test="${incomeChange != null}">
	                    <div class="ie-card-change ${incomeChange > 0 ? 'up' : 'down'}">
	                        ${incomeChange > 0 ? '▲' : '▼'} 
	                        <fmt:formatNumber value="${incomeChange}" pattern="#,###"/>원
	                    </div>
	                    <div class="ie-card-comment">
	                    	<c:if test="${incomeChange > 0}">
	                        	<span>👍 수입이 늘었어요.</span>
	                        </c:if>
	                        <c:if test="${incomeChange < 0}">
	                        	<span>😒 수입이 줄었어요.</span>
	                        </c:if>
	                    </div>
	                </c:if>
	            </div>
	        </div>
	    </div>
	    
	    <!-- 빠른 메뉴 -->
	    <div class="quick-menu">
	        <div class="quick-menu-grid">
	            <a href="${ctx}/accounts/list" class="quick-menu-item">
	                <div class="quick-menu-icon accounts"><i class="i01"></i></div>
	                <div class="quick-menu-text">계좌 연결</div>
	            </a>
	            <a href="${ctx}/cards/list" class="quick-menu-item">
	                <div class="quick-menu-icon cards"><i class="i02"></i></div>
	                <div class="quick-menu-text">카드 등록</div>
	            </a>
	            <a href="${ctx}/ai/chat" class="quick-menu-item">
	                <div class="quick-menu-icon chatbot"><i class="i03"></i></div>
	                <div class="quick-menu-text">센스봇</div>
	            </a>
	            <a href="${ctx}/ledger/calendar" class="quick-menu-item">
	                <div class="quick-menu-icon ledger"><i class="i04"></i></div>
	                <div class="quick-menu-text">가계부</div>
	            </a>
	        </div>
	    </div>
	    
	    <!-- AI 챗봇 배너 -->
	    <div class="chatbot-banner">
	        <div class="chatbot-icon"></div>
	        <div class="chatbot-text">
	            ${chatbotMessage}
	        </div>
	    </div>
	    
	    <!-- 카테고리별 소비 그래프 -->
	    <div class="category-section">
	        <div class="section-title">나의 카테고리별 소비 그래프</div>
	        <div class="chart-container">
	            <canvas id="categoryChart"></canvas>
	        </div>
	    </div>
    </div>
</div>
<script>
$(document).ready(function() {
    
    // 카테고리 데이터
    var categoryData = [
        <c:forEach var="item" items="${categoryExpense}" varStatus="status">
            {
                name: '${item.categoryName}',
                amount: ${item.totalAmount}
            }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    console.log('카테고리 데이터:', categoryData);
    
    // 그래프 생성
    if (categoryData.length > 0) {
        createCategoryChart(categoryData);
    }
    
    function createCategoryChart(data) {
        const ctx = document.getElementById('categoryChart').getContext('2d');

        const labels = data.map(item => item.name);
        const amounts = data.map(item => item.amount);

        // 색상 배열
        const colors = [
            '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
            '#9966FF', '#FF9F40', '#FF6384', '#C9CBCF', '#4BC0C0'
        ];

        // 플러그인 등록
        Chart.register(ChartDataLabels);

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: amounts,
                    backgroundColor: colors.slice(0, labels.length),
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            padding: 15,
                            font: {
                                size: 12
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const total = amounts.reduce((a, b) => a + b, 0);
                                const percentage = ((context.parsed / total) * 100).toFixed(1);
                                return context.label + ': ' +
                                       context.parsed.toLocaleString() + '원 (' +
                                       percentage + '%)';
                            }
                        }
                    },
                    datalabels: {
                        color: '#fff',
                        font: {
                            weight: 'bold',
                            size: 14
                        },
                        formatter: function(value, context) {
                            const total = amounts.reduce((a, b) => a + b, 0);
                            const percentage = ((value / total) * 100).toFixed(1);

                            // 5% 이상인 것만 표시
                            if (percentage >= 5) {
                                return percentage + '%';
                            }
                            return '';
                        }
                    }
                }
            }
        });
    }
});
</script>
<%@ include file="include/Fixed.jsp"%>