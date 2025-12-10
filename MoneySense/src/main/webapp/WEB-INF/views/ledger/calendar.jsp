<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file ="../include/Header.jsp"%>
<!-- jQuery -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- FullCalendar -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js"></script>

<!-- Bootstrap for Modal -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Flatpickr -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/themes/material_blue.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<!-- Flatpickr Month Select Plugin -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/style.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/index.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

<style>
    /* Summary */
    #summaryRow {
        display: flex;
        flex-direction: column;
        gap: 8px;
        background: white;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    #summaryRow > div {
        font-size: 15px;
        color: #333;
    }
    
    #monthExpense {
        color: #dc3545;
        font-weight: bold;
    }
    
    #monthIncome {
        color: #28a745;
        font-weight: bold;
    }
    
    #monthNet {
        color: #007bff;
        font-weight: bold;
    }
    
    /* Month Picker */
    .picker-box {
        margin-bottom: 15px;
    }
    
    #monthPicker, #weekPicker {
        width: 200px;
        border-radius: 6px;
        border: 1px solid #cfd3d7;
        padding: 10px 12px;
        transition: 0.2s;
    }
    
    #monthPicker:focus, #weekPicker:focus {
        border-color: #4c8bf5;
        box-shadow: 0 0 3px rgba(76, 139, 245, 0.5);
    }
    
    /* Buttons */
    .view-buttons {
        margin-bottom: 15px;
    }
    
    /* Calendar */
    #calendar {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    .daily-spend {
        margin-top: 5px;
        font-size: 11px;
        color: #666;
        text-align: right;
        padding-right: 4px;
    }
    
    .fc-daygrid-day {
        transition: background-color 0.2s ease;
        cursor: pointer;
    }
    
    .fc-daygrid-day:hover {
        background: rgba(0, 123, 255, 0.05);
    }
    
    /* Modal */
    .transaction-item {
        padding: 15px;
        border-bottom: 1px solid #dee2e6;
        cursor: pointer;
        transition: background 0.2s;
    }
    
    .transaction-item:hover {
        background: #f8f9fa;
    }
    
    .transaction-item:last-child {
        border-bottom: none;
    }
    
    .transaction-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 5px;
    }
    
    .transaction-time {
        font-size: 12px;
        color: #6c757d;
    }
    
    .transaction-amount {
        font-size: 16px;
        font-weight: bold;
    }
    
    .amount-income {
        color: #28a745;
    }
    
    .amount-expense {
        color: #dc3545;
    }
    
    .transaction-detail {
        font-size: 14px;
        color: #333;
        margin-bottom: 3px;
    }
    
    .transaction-source {
        font-size: 12px;
        color: #6c757d;
    }
    
    /* Detail Modal */
    .detail-row {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid #dee2e6;
    }
    
    .detail-row:last-child {
        border-bottom: none;
    }
    
    .detail-label {
        font-weight: bold;
        color: #495057;
    }
    
    .detail-value {
        color: #333;
    }
    
    /* Mobile */
    @media (max-width: 768px) {
        body {
            padding: 10px;
        }
        
        h1 {
            font-size: 22px;
        }
        
        #summaryRow {
            padding: 15px;
            font-size: 13px;
        }
        
        #monthPicker, #weekPicker {
            width: 100%;
        }
        
        .btn {
            font-size: 13px;
            padding: 8px 16px;
        }
        
        .fc-toolbar-title {
            font-size: 18px !important;
        }
        
        .fc-daygrid-day-number {
            font-size: 11px !important;
        }
        
        .daily-spend {
            font-size: 10px;
        }
    }
</style>
<div id="subContents">
	<div class="fix-layout">
		<div class="container">
			<h1 class="page-title">💰 가계부</h1>
	        <!-- Summary -->
	        <div id="summaryRow">
	            <div id="monthExpense">이번달 총 지출: 0원</div>
	            <div id="monthIncome">이번달 총 수입: 0원</div>
	            <div id="monthNet">순 변화: 0원</div>
	        </div>
	        
	        <!-- Month Picker -->
	        <div id="monthPickerBox" class="picker-box">
	            <input id="monthPicker" placeholder="월 선택" class="form-control">
	        </div>
	        
	        <!-- Week Picker -->
	        <div id="weekPickerBox" class="picker-box" style="display:none;">
	            <input id="weekPicker" placeholder="날짜 선택" class="form-control">
	        </div>
	        
	        <!-- View Buttons -->
	        <div class="view-buttons">
	            <button id="monthViewBtn" class="btn btn-primary">월 보기</button>
	            <button id="weekViewBtn" class="btn btn-secondary">주 보기</button>
	        </div>
	        
	        <!-- Calendar -->
	        <div id="calendar"></div>			
		</div>
	</div>
</div>
<!-- Daily Modal (일별 내역) -->
<div class="modal fade" id="dailyModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="dailyModalTitle">거래 내역</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="dailyList"></div>
            </div>
        </div>
    </div>
</div>
<!-- Detail Modal (거래 상세) -->
<div class="modal fade" id="detailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">거래 상세</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="detailContent"></div>
            </div>
        </div>
    </div>
</div>
<script>
$(document).ready(function() {
    
    const csrfToken = '${_csrf.token}';
    const csrfHeader = '${_csrf.headerName}';
    
    let calendar;
    let currentYear = new Date().getFullYear();
    let currentMonth = new Date().getMonth() + 1;
    let dailyTotalsMap = {};
    
    // ========================================
    // FullCalendar 초기화
    // ========================================
    calendar = new FullCalendar.Calendar(document.getElementById("calendar"), {
        initialView: "dayGridMonth",
        locale: "ko",
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: ''
        },
        buttonText: {
            today: "오늘",
            month: "월",
            week: "주",
            day: "일",
            list: "리스트"
        },
        height: "auto",
        events: [],
        
        // 날짜 클릭
        dateClick: function(info) {
            openDailyModal(info.dateStr);
        },
        
        // 이벤트 클릭
        eventClick: function(info) {
            openDailyModal(info.event.startStr);
        },
        
        // 날짜 셀 렌더링
        dayCellDidMount: function(info) {
            let date = info.date.toISOString().slice(0, 10);
            let total = dailyTotalsMap[date] || 0;
            let maxSpend = 100000;
            
            // 지출이 있으면 배경색 (히트맵)
            if(total < 0) {
                let ratio = Math.min(Math.abs(total) / maxSpend, 1);
                info.el.style.backgroundColor = 'rgba(255, 130, 130, ' + (ratio * 0.3) + ')';
            }
            
            // 일별 합계 표시
            if(total !== 0) {
                info.el.insertAdjacentHTML("beforeend",
                    '<div class="daily-spend">' + total.toLocaleString() + '원</div>'
                );
            }
        },
        
        // 날짜 범위 변경
        datesSet: function(info) {
            let date = info.view.currentStart;
            currentYear = date.getFullYear();
            currentMonth = date.getMonth() + 1;
            loadMonthlyData(currentYear, currentMonth);
        }
    });
    
    calendar.render();
    
    // ========================================
    // 월별 데이터 로딩
    // ========================================
    function loadMonthlyData(year, month) {
        console.log('월별 데이터 로딩: ' + year + '년 ' + month + '월');
        
        $.ajax({
            url: '${pageContext.request.contextPath}/ledger/month',
            type: 'GET',
            data: {
                year: year,
                month: month
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(data) {
                console.log('데이터 로딩 성공:', data);
                
                // 캘린더 이벤트 업데이트
                calendar.removeAllEvents();
                calendar.addEventSource(data.events);
                
                // 일별 합계 저장
                dailyTotalsMap = data.dailyTotals;
                
                // Summary 업데이트
                updateSummary(data.summary);
                
                // 캘린더 리렌더링 (히트맵 업데이트)
                calendar.refetchEvents();
            },
            error: function(xhr, status, error) {
                console.error('데이터 로딩 실패:', error);
                alert('데이터를 불러오는데 실패했습니다.');
            }
        });
    }
    
    // ========================================
    // Summary 업데이트
    // ========================================
    function updateSummary(summary) {
        $('#monthExpense').text('이번달 총 지출: ' + summary.expense.toLocaleString() + '원');
        $('#monthIncome').text('이번달 총 수입: ' + summary.income.toLocaleString() + '원');
        $('#monthNet').text('순 변화: ' + summary.net.toLocaleString() + '원');
    }
    
    // ========================================
    // 일별 모달 열기
    // ========================================
    function openDailyModal(dateStr) {
        console.log('일별 모달 열기:', dateStr);
        
        $.ajax({
            url: '${pageContext.request.contextPath}/ledger/day',
            type: 'GET',
            data: {
                date: dateStr
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(data) {
                console.log('일별 데이터:', data);
                
                $('#dailyModalTitle').text(dateStr + ' 거래 내역');
                
                let html = '';
                
                if(data.transactions.length == 0) {
                    html = '<div class="text-center p-4 text-muted">거래 내역이 없습니다</div>';
                } else {
                    data.transactions.forEach(function(tx) {
                        let time = new Date(tx.transactedAt).toLocaleTimeString('ko-KR', {
                            hour: '2-digit',
                            minute: '2-digit'
                        });
                        
                        let amountClass = tx.inoutType == 'I' ? 'amount-income' : 'amount-expense';
                        let amountSign = tx.inoutType == 'I' ? '+' : '-';
                        let icon = tx.transactionType == 'BANK' ? '🏦' : '💳';
                        
                        html += '<div class="transaction-item" data-key="' + tx.transactionKey + '">' +
                                    '<div class="transaction-header">' +
                                        '<span class="transaction-time">' + time + '</span>' +
                                        '<span class="transaction-amount ' + amountClass + '">' +
                                            amountSign + Math.abs(tx.amount).toLocaleString() + '원' +
                                        '</span>' +
                                    '</div>' +
                                    '<div class="transaction-detail">' + tx.detail + '</div>' +
                                    '<div class="transaction-source">' +
                                        icon + ' ' + tx.sourceName +
                                    '</div>' +
                                '</div>';
                    });
                }
                
                $('#dailyList').html(html);
                
                // 모달 표시
                new bootstrap.Modal(document.getElementById('dailyModal')).show();
            },
            error: function(xhr, status, error) {
                console.error('일별 데이터 로딩 실패:', error);
                alert('데이터를 불러오는데 실패했습니다.');
            }
        });
    }
    
    // ========================================
    // 거래 상세 모달 열기
    // ========================================
    $(document).on('click', '.transaction-item', function() {
        let key = $(this).data('key');
        console.log('거래 상세 열기:', key);
        
        $.ajax({
            url: '${pageContext.request.contextPath}/ledger/detail',
            type: 'GET',
            data: {
                key: key
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(tx) {
                console.log('거래 상세:', tx);
                
                let datetime = new Date(tx.transactedAt).toLocaleString('ko-KR');
                let amountSign = tx.inoutType == 'I' ? '+' : '-';
                let type = tx.transactionType == 'BANK' ? '계좌 거래' : '카드 사용';
                let amountColor = tx.inoutType == 'I' ? '#28a745' : '#dc3545';
                
                let html = '<div class="detail-row">' +
                                '<span class="detail-label">구분</span>' +
                                '<span class="detail-value">' + type + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<span class="detail-label">일시</span>' +
                                '<span class="detail-value">' + datetime + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<span class="detail-label">내역</span>' +
                                '<span class="detail-value">' + tx.detail + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<span class="detail-label">금액</span>' +
                                '<span class="detail-value" style="font-size:18px; font-weight:bold; color:' + amountColor + '">' +
                                    amountSign + Math.abs(tx.amount).toLocaleString() + '원' +
                                '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<span class="detail-label">' + (tx.transactionType == 'BANK' ? '은행' : '카드사') + '</span>' +
                                '<span class="detail-value">' + tx.sourceName + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<span class="detail-label">' + (tx.transactionType == 'BANK' ? '계좌번호' : '카드번호') + '</span>' +
                                '<span class="detail-value">' + tx.sourceNumber + '</span>' +
                            '</div>';
                
                // 계좌 거래면 잔액 표시
                if(tx.transactionType == 'BANK' && tx.balanceAfter !== null) {
                    html += '<div class="detail-row">' +
                                '<span class="detail-label">거래 후 잔액</span>' +
                                '<span class="detail-value">' + tx.balanceAfter.toLocaleString() + '원</span>' +
                            '</div>';
                }
                
                // 카드면 할부 표시
                if(tx.transactionType == 'CARD' && tx.installment > 0) {
                    html += '<div class="detail-row">' +
                                '<span class="detail-label">할부</span>' +
                                '<span class="detail-value">' + tx.installment + '개월</span>' +
                            '</div>';
                }
                
                // 메모
                if(tx.memo) {
                    html += '<div class="detail-row">' +
                                '<span class="detail-label">메모</span>' +
                                '<span class="detail-value">' + tx.memo + '</span>' +
                            '</div>';
                }
                
                $('#detailContent').html(html);
                
                // Daily 모달 숨기고 Detail 모달 표시
                bootstrap.Modal.getInstance(document.getElementById('dailyModal')).hide();
                new bootstrap.Modal(document.getElementById('detailModal')).show();
            },
            error: function(xhr, status, error) {
                console.error('거래 상세 로딩 실패:', error);
                alert('데이터를 불러오는데 실패했습니다.');
            }
        });
    });
    
    // ========================================
    // 월 보기 / 주 보기 전환
    // ========================================
    $('#monthViewBtn').click(function() {
        calendar.changeView('dayGridMonth');
        calendar.gotoDate(new Date());
        
        setTimeout(function() {
            $('#monthPickerBox').show();
            $('#weekPickerBox').hide();
        }, 10);
    });
    
    $('#weekViewBtn').click(function() {
        calendar.changeView('listWeek');
        calendar.gotoDate(new Date());
        
        setTimeout(function() {
            $('#weekPickerBox').show();
            $('#monthPickerBox').hide();
        }, 10);
    });
    
    // ========================================
    // Flatpickr 초기화
    // ========================================
    flatpickr("#monthPicker", {
        locale: "ko",
        plugins: [
            new monthSelectPlugin({
                shorthand: true,
                dateFormat: "Y-m",
                altFormat: "Y년 m월",
                theme: "material_blue"
            })
        ],
        onChange: function(selected) {
            const date = selected[0];
            calendar.changeView("dayGridMonth");
            calendar.gotoDate(date);
        }
    });
    
    flatpickr("#weekPicker", {
        locale: "ko",
        dateFormat: "Y-m-d",
        theme: "material_blue",
        onChange: function(selected) {
            if(!selected || selected.length == 0) return;
            
            const date = selected[0];
            calendar.changeView("listWeek");
            calendar.gotoDate(date);
            
            setTimeout(function() {
                $('#weekPickerBox').show();
                $('#monthPickerBox').hide();
            }, 10);
        }
    });
    
});
</script>
<%@ include file ="../include/Footer.jsp"%>