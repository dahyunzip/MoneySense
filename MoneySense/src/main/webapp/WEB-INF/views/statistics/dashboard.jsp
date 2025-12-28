<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/Header.jsp"%>
<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>

<div id="subContents" class="statistics">
    <div class="fix-layout">
        <div class="container">
            <!-- 헤더 -->
            <div class="dashboard-header">
                <h1 class="page-title">소비 통계 대시보드</h1>
                <p class="page-sub-title">나의 소비 패턴을 한눈에 확인해보세요</p>
            </div>
            
            <!-- 차트 그리드 -->
            <div class="chart-grid" id="chartGrid">
                <div class="loading">데이터를 불러오는 중...</div>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    
    const csrfToken = '${_csrf.token}';
    const csrfHeader = '${_csrf.headerName}';
    
    let charts = {};
    
    Chart.register(ChartDataLabels);
    
    // 데이터 로드
    function loadDashboardData() {
        $.ajax({
            url: '${ctx}/statistics/data',
            type: 'GET',
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(data) {
                console.log('대시보드 데이터:', data);
                renderCharts(data);
            },
            error: function(xhr, status, error) {
                console.error('데이터 로드 오류:', error);
                $('#chartGrid').html('<div class="loading">데이터를 불러오는데 실패했습니다.</div>');
            }
        });
    }
    
    // 차트 렌더링
    function renderCharts(data) {
        const chartHtml = 
            '<div class="chart-card">' +
                '<h3 class="chart-title">이 달의 카테고리별 지출</h3>' +
                '<div class="chart-container">' +
                    '<canvas id="categoryChart"></canvas>' +
                '</div>' +
            '</div>' +
            
            '<div class="chart-card">' +
                '<h3 class="chart-title">카테고리별 전월 대비 증감</h3>' +
                '<div class="chart-container">' +
                    '<canvas id="changeRateChart"></canvas>' +
                '</div>' +
            '</div>' +
            
            '<div class="chart-card">' +
                '<h3 class="chart-title">주간 지출 추세</h3>' +
                '<div class="chart-container">' +
                    '<canvas id="weeklyChart"></canvas>' +
                '</div>' +
            '</div>' +
            
            '<div class="chart-card">' +
                '<h3 class="chart-title">월별 소비 트렌드 (최근 6개월)</h3>' +
                '<div class="chart-container">' +
                    '<canvas id="monthlyChart"></canvas>' +
                '</div>' +
            '</div>';
        
        $('#chartGrid').html(chartHtml);
        
        // 차트 생성
        createCategoryChart(data.categoryExpense);
        createChangeRateChart(data.categoryChange);
        createWeeklyChart(data.weeklyTrend);
        createMonthlyChart(data.monthlyTrend);
    }
    
    // 카테고리별 지출 차트 (도넛 차트)
    function createCategoryChart(data) {
        const ctx = document.getElementById('categoryChart').getContext('2d');
        
        const labels = data.map(item => item.categoryName);
        const amounts = data.map(item => item.totalAmount);
        const total = amounts.reduce((a, b) => a + b, 0);
        
        charts.category = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: amounts,
                    backgroundColor: [
                        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                        '#9966FF', '#FF9F40', '#FF6384', '#C9CBCF', '#4BC0C0'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
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
    
    // 증감률 차트 (막대 차트)
    function createChangeRateChart(data) {
        const ctx = document.getElementById('changeRateChart').getContext('2d');
        
        const labels = data.map(item => item.categoryName);
        const rates = data.map(item => item.changeRate);
        
        charts.changeRate = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '증감률 (%)',
                    data: rates,
                    backgroundColor: rates.map(r => r >= 0 ? '#FF6384' : '#36A2EB')
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y.toFixed(1) + '%';
                            }
                        }
                    },
                    datalabels: {
                        anchor: 'end',
                        align: 'end',
                        color: '#333',
                        font: {
                            weight: 'bold',
                            size: 11
                        },
                        formatter: function(value) {
                            if (value === 0) return '';
                            return value.toFixed(1) + '%';
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value + '%';
                            }
                        }
                    }
                }
            }
        });
    }
    
    // 주간 지출 추세 차트 (라인 차트)
    function createWeeklyChart(data) {
        const ctx = document.getElementById('weeklyChart').getContext('2d');
        
        const labels = data.map(item => item.weekLabel);
        const amounts = data.map(item => item.totalAmount);
        
        charts.weekly = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: '주간 지출',
                    data: amounts,
                    borderColor: '#36A2EB',
                    backgroundColor: 'rgba(54, 162, 235, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return '지출: ' + context.parsed.y.toLocaleString() + '원';
                            }
                        }
                    },
                    datalabels: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString() + '원';
                            }
                        }
                    }
                }
            }
        });
    }
    
    // 월별 소비 트렌드 차트 (막대 + 라인)
    function createMonthlyChart(data) {
        const ctx = document.getElementById('monthlyChart').getContext('2d');
        
        const labels = data.map(item => item.monthLabel);
        const amounts = data.map(item => item.totalAmount);
        
        charts.monthly = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '월별 지출',
                    data: amounts,
                    backgroundColor: '#FFCE56',
                    borderColor: '#FFCE56',
                    borderWidth: 1,
                    datalabels: {
                        anchor: 'end',
                        align: 'end',
                        color: '#333',
                        font: {
                            weight: 'bold',
                            size: 11
                        },
                        formatter: function(value) {
                            if (value === 0) return '';
                            return (value / 10000).toFixed(0) + '만원';
                        }
                    }
                }, {
                    label: '추세선',
                    data: amounts,
                    type: 'line',
                    borderColor: '#FF6384',
                    backgroundColor: 'transparent',
                    tension: 0.4,
                    pointRadius: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                if (context.datasetIndex === 0) {
                                    return '지출: ' + context.parsed.y.toLocaleString() + '원';
                                }
                                return null;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString() + '원';
                            }
                        }
                    }
                }
            }
        });
    }
    
    // 초기 로드
    loadDashboardData();
});
</script>

<%@ include file="../include/Fixed.jsp"%>