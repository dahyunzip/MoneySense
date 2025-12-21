<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file ="../include/Header.jsp"%>
<!-- FullCalendar -->
<script src="${ctx }/resources/js/index.global.min.js"></script>

<!-- Bootstrap for Modal -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link href="${ctx }/resources/css/bootstrap.min.css" rel="stylesheet">

<script src="${ctx}/resources/js/jquery-ui.min.js"></script>
<link rel="stylesheet" href="${ctx}/resources/css/jquery-ui.css">

<style>
.fc-theme-standard th{border-right:0 !important; border-left:0 !important; }
.fc-theme-standard td{border-right:0 !important; border-left:0 !important;}
#calendar .fc-scrollgrid{border:0 !important;}
/* 카테고리 배지 (일별 모달) */
.category-badge {
    display: inline-block;
    padding: 2px 8px;
    background-color: #e3f2fd;
    color: #1976d2;
    border-radius: 4px;
    font-size: 11px;
    font-weight: 500;
    margin-left: 8px;
}

/* 카테고리 배지 (상세 모달) */
.category-badge-detail {
    display: inline-block;
    padding: 4px 12px;
    background-color: #e3f2fd;
    color: #1976d2;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 500;
}
</style>

<div id="subContents">
	<div class="fix-layout" id="calendarPage">
		<div id="calendarHead">
			<div id="monthWrap">
				<input id="monthPicker" placeholder="월 선택" class="text-like" readonly>
			</div>
			<!-- 소비 요약 -->
	        <div id="summaryRow">
	            <div id="monthIncome"></div>
	            <div id="monthExpense"></div>
	            <!-- <div id="monthNet">순 변화: 0원</div> -->
	        </div>
		</div>
        
        <!-- Week Picker -->
        <div id="weekPickerBox" class="picker-box" style="display:none;">
            <input id="weekPicker" placeholder="날짜 선택" class="form-control" readonly>
        </div>
        
        <!-- View Buttons -->
        <!-- <div class="view-buttons">
            <button id="monthViewBtn" class="btn btn-primary">월 보기</button>
            <button id="weekViewBtn" class="btn btn-secondary">주 보기</button>
        </div> -->
        
        <!-- Calendar -->
        <div id="calendar"></div>			
	</div>
</div>

<!-- Month Picker Modal -->
<div class="modal fade" id="monthPickerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">월 선택</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="year-selector">
                    <button type="button" class="btn btn-outline-secondary btn-sm" id="prevYear">&lt;</button>
                    <span class="year-display" id="yearDisplay"></span>
                    <button type="button" class="btn btn-outline-secondary btn-sm" id="nextYear">&gt;</button>
                </div>
                <div class="month-grid" id="monthGrid"></div>
            </div>
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
    let dailySummaryMap = {};
    let isLoading = false;
    let isInitializing = false;
    
    let selectedYear = new Date().getFullYear();
    let selectedMonth = new Date().getMonth() + 1;
    let monthPickerModalInstance;
    
    // ========================================
    // FullCalendar 초기화
    // ========================================
    function initCalendar() {
    	isInitializing = true;
    	
        if(calendar) {
            calendar.destroy();
        }
        
        calendar = new FullCalendar.Calendar(document.getElementById("calendar"), {
            initialView: "dayGridMonth",
            locale: "ko",
            initialDate: new Date(currentYear, currentMonth - 1, 1),
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: ''
            },
            buttonText: {
                today: "오늘"
            },
            height: "auto",
            timeZone: 'local',
            dateClick: function(info) {
                openDailyModal(info.dateStr);
            },
            
            dayCellDidMount: function(info) {
            	let year = info.date.getFullYear();
                let month = String(info.date.getMonth() + 1).padStart(2, '0');
                let day = String(info.date.getDate()).padStart(2, '0');
                let date = year + '-' + month + '-' + day;
                
                let summary = dailySummaryMap[date];
                
                if(!summary) return;
                
                let income = summary.income || 0;
                let expense = summary.expense || 0;
                
                let html = '';
                
             	// 지출 표시
                if(expense != 0) {
                    let expenseDisplay = expense < 0 ? expense : -expense;  // 음수로 변환
                    html += '<div style="color:#7B838D; font-size:8px; font-weight:500;">' +
                    expenseDisplay.toLocaleString() + '</div>';
                }
                
                // 수입 표시
                if(income > 0) {
                	html += '<div style="color:#00AEEE; font-size:8px; font-weight:500;">+' +
                    income.toLocaleString() + '</div>';
                }
                
                if(html) {
                    info.el.insertAdjacentHTML("beforeend", html);
                }
                
            },
            
            datesSet: function(info) {
            	if(isInitializing) {
                    isInitializing = false;
                    return;
                }
            	
                let date = info.view.currentStart;
                let newYear = date.getFullYear();
                let newMonth = date.getMonth() + 1;
                
                console.log('datesSet 이벤트:', newYear + '년 ' + newMonth + '월');
                
                if(newYear != currentYear || newMonth != currentMonth) {
                    currentYear = newYear;
                    currentMonth = newMonth;
                    
                    // 월 표시 업데이트
                    let monthText = newYear + '년 ' + newMonth.toString().padStart(2, '0') + '월';
                    $('#monthPicker').val(monthText);
                    
                    // 데이터 로딩 (캘린더 재생성 포함)
                    loadMonthlyDataOnly(newYear, newMonth);
                }
            }
        });
        
        calendar.render();
        isInitializing = false;
    }
    
 	// ========================================
    // 월별 데이터만 로딩 (캘린더 재생성 안함)
    // ========================================
    function loadMonthlyDataOnly(year, month) {
        if(isLoading) {
            console.log('이미 로딩 중...');
            return;
        }
        
        isLoading = true;
        console.log('월별 데이터만 로딩: ' + year + '년 ' + month + '월');
        
        $.ajax({
            url: '${ctx}/ledger/month',
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
                
                dailyTotalsMap = data.dailyTotals;
                
                if(data.dailySummary) {
                    dailySummaryMap = data.dailySummary;
                } else {
                    console.log('dailySummary가 없습니다.');
                    dailySummaryMap = {};
                }
                
                console.log('dailySummaryMap:', dailySummaryMap);
                
                updateSummary(data.summary);
                
                initCalendar();
                
                isLoading = false;
            },
            error: function(xhr, status, error) {
                console.error('데이터 로딩 실패:', error);
                alert('데이터를 불러오는데 실패했습니다.');
                isLoading = false;
            }
        });
    }
    
	// ========================================
    // 월별 데이터 로딩 (캘린더 재생성 포함)
    // ========================================
    function loadMonthlyData(year, month) {
        if(isLoading) {
            console.log('이미 로딩 중...');
            return;
        }
        
        isLoading = true;
        console.log('월별 데이터 로딩: ' + year + '년 ' + month + '월');
        
        currentYear = year;
        currentMonth = month;
        
        $.ajax({
            url: '${ctx}/ledger/month',
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
                
                dailyTotalsMap = data.dailyTotals;
                
                if(data.dailySummary) {
                    dailySummaryMap = data.dailySummary;
                } else {
                    console.log('dailySummary가 없습니다.');
                    dailySummaryMap = {};
                }
                
                console.log('dailySummaryMap:', dailySummaryMap);
                
                updateSummary(data.summary);
                
                initCalendar();
                
                let monthText = year + '년 ' + month.toString().padStart(2, '0') + '월';
                $('#monthPicker').val(monthText);
                
                isLoading = false;
            },
            error: function(xhr, status, error) {
                console.error('데이터 로딩 실패:', error);
                alert('데이터를 불러오는데 실패했습니다.');
                isLoading = false;
            }
        });
    }
    
    // ========================================
    // Summary 업데이트
    // ========================================
    function updateSummary(summary) {
        $('#monthExpense').html('<span>지출</span>' + summary.expense.toLocaleString() + '원');
        $('#monthIncome').html('<span>수입</span>' + summary.income.toLocaleString() + '원');
    }
    
    // ========================================
    // 일별 모달 열기
    // ========================================
    function openDailyModal(dateStr) {
        console.log('일별 모달 열기:', dateStr);
        
        $.ajax({
            url: '${ctx}/ledger/day',
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
                        
                        let categoryBadge = '';
                        if(tx.categoryName && tx.inoutType == 'O') {
                            categoryBadge = '<span class="category-badge">' + tx.categoryName + '</span>';
                        }
                        
                        html += '<div class="transaction-item" data-key="' + tx.transactionKey + '">' +
                                    '<div class="transaction-header">' +
                                        '<span class="transaction-time">' + time + '</span>' +
                                    '</div>' +
                                    '<div class="transaction-header">' + 
                                    	'<div class="transaction-detail">' + tx.detail + '</div>' +
                                    	'<span class="transaction-amount ' + amountClass + '">' +
                                        	amountSign + Math.abs(tx.amount).toLocaleString() + '원' +
                                    	'</span>' +
                                    '</div>'+
                                    '<div class="transaction-source">' +
                                        icon + ' ' + tx.sourceName +
                                    '</div>' +
                                '</div>';
                    });
                }
                
                $('#dailyList').html(html);
                
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
            url: '${ctx}/ledger/detail',
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
                            '</div>';
                         	// 카테고리 추가
                            if(tx.categoryName && tx.inoutType == 'O') {
                                html += '<div class="detail-row">' +
                                            '<span class="detail-label">카테고리</span>' +
                                            '<span class="detail-value">' + tx.categoryName + '</span>' +
                                            '</span>' +
                                        '</div>';
                            }
                            html += '<div class="detail-row">' +
                                '<span class="detail-label">' + (tx.transactionType == 'BANK' ? '은행' : '카드사') + '</span>' +
                                '<span class="detail-value">' + tx.sourceName + '</span>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<span class="detail-label">' + (tx.transactionType == 'BANK' ? '계좌번호' : '카드번호') + '</span>' +
                                '<span class="detail-value">' + tx.sourceNumber + '</span>' +
                            '</div>';
                
                if(tx.transactionType == 'BANK' && tx.balanceAfter !== null) {
                    html += '<div class="detail-row">' +
                                '<span class="detail-label">거래 후 잔액</span>' +
                                '<span class="detail-value">' + tx.balanceAfter.toLocaleString() + '원</span>' +
                            '</div>';
                }
                
                if(tx.transactionType == 'CARD' && tx.installment > 0) {
                    html += '<div class="detail-row">' +
                                '<span class="detail-label">할부</span>' +
                                '<span class="detail-value">' + tx.installment + '개월</span>' +
                            '</div>';
                }
                
                if(tx.memo) {
                    html += '<div class="detail-row">' +
                                '<span class="detail-label">메모</span>' +
                                '<span class="detail-value">' + tx.memo + '</span>' +
                            '</div>';
                }
                
                $('#detailContent').html(html);
                
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
    // 월 선택 모달 초기화
    // ========================================
    function initMonthPicker() {
        const monthNames = ['1월', '2월', '3월', '4월', '5월', '6월', 
                           '7월', '8월', '9월', '10월', '11월', '12월'];
        
        function renderMonthGrid() {
            $('#yearDisplay').text(selectedYear + '년');
            
            let html = '';
            for(let i = 0; i < 12; i++) {
                let isSelected = (selectedYear == currentYear && (i + 1) == currentMonth) ? 'selected' : '';
                html += '<div class="month-item ' + isSelected + '" data-month="' + (i + 1) + '">' + 
                        monthNames[i] + '</div>';
            }
            
            $('#monthGrid').html(html);
        }
        
        $('#prevYear').off('click').on('click', function() {
            selectedYear--;
            renderMonthGrid();
        });
        
        $('#nextYear').off('click').on('click', function() {
            selectedYear++;
            renderMonthGrid();
        });
        
        $(document).off('click', '.month-item').on('click', '.month-item', function() {
            selectedMonth = parseInt($(this).data('month'));
            
            //월 선택 시 캘린더 재생성
            loadMonthlyData(selectedYear, selectedMonth);
            
            monthPickerModalInstance.hide();
        });
        
        renderMonthGrid();
    }
    
    $('#monthPicker').click(function() {
        selectedYear = currentYear;
        selectedMonth = currentMonth;
        
        if(!monthPickerModalInstance) {
            monthPickerModalInstance = new bootstrap.Modal(document.getElementById('monthPickerModal'));
            initMonthPicker();
        }
        
        selectedYear = currentYear;
        selectedMonth = currentMonth;
        $('#yearDisplay').text(selectedYear + '년');
        
        const monthNames = ['1월', '2월', '3월', '4월', '5월', '6월', 
                           '7월', '8월', '9월', '10월', '11월', '12월'];
        let html = '';
        for(let i = 0; i < 12; i++) {
            let isSelected = (selectedYear == currentYear && (i + 1) == currentMonth) ? 'selected' : '';
            html += '<div class="month-item ' + isSelected + '" data-month="' + (i + 1) + '">' + 
                    monthNames[i] + '</div>';
        }
        $('#monthGrid').html(html);
        
        monthPickerModalInstance.show();
    });
 	// ========================================
    // 초기 실행
    // ========================================
    let now = new Date();
    let currentMonthText = now.getFullYear() + '년 ' + 
                          (now.getMonth() + 1).toString().padStart(2, '0') + '월';
    $('#monthPicker').val(currentMonthText);
    
    loadMonthlyData(currentYear, currentMonth);
    
});
</script>
<%@ include file ="../include/Fixed.jsp"%>