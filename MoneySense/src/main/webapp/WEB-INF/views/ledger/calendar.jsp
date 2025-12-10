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

<div id="subContents">
	<div class="fix-layout" id="calendarPage">
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
	            <input id="monthPicker" placeholder="월 선택" class="form-control" readonly>
	        </div>
	        
	        <!-- Week Picker -->
	        <div id="weekPickerBox" class="picker-box" style="display:none;">
	            <input id="weekPicker" placeholder="날짜 선택" class="form-control" readonly>
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
    
    let selectedYear = new Date().getFullYear();
    let selectedMonth = new Date().getMonth() + 1;
    let monthPickerModalInstance;
    
    // jQuery UI Datepicker 한국어 설정
    $.datepicker.regional['ko'] = {
        closeText: '닫기',
        prevText: '이전달',
        nextText: '다음달',
        currentText: '오늘',
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'],
        dayNamesShort: ['일','월','화','수','목','금','토'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
        weekHeader: 'Wk',
        dateFormat: 'yy-mm-dd',
        firstDay: 0,
        isRTL: false,
        showMonthAfterYear: true,
        yearSuffix: '년'
    };
    $.datepicker.setDefaults($.datepicker.regional['ko']);
    
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
    // 월 선택 모달 초기화
    // ========================================
    function initMonthPicker() {
        const monthNames = ['1월', '2월', '3월', '4월', '5월', '6월', 
                           '7월', '8월', '9월', '10월', '11월', '12월'];
        
        // 월 그리드 생성
        function renderMonthGrid() {
            $('#yearDisplay').text(selectedYear + '년');
            
            let html = '';
            for(let i = 0; i < 12; i++) {
                let isSelected = (selectedYear === currentYear && (i + 1) === currentMonth) ? 'selected' : '';
                html += '<div class="month-item ' + isSelected + '" data-month="' + (i + 1) + '">' + 
                        monthNames[i] + '</div>';
            }
            
            $('#monthGrid').html(html);
        }
        
        // 이전 년도
        $('#prevYear').click(function() {
            selectedYear--;
            renderMonthGrid();
        });
        
        // 다음 년도
        $('#nextYear').click(function() {
            selectedYear++;
            renderMonthGrid();
        });
        
        // 월 선택
        $(document).on('click', '.month-item', function() {
            selectedMonth = parseInt($(this).data('month'));
            
            // 선택된 월로 이동
            let date = new Date(selectedYear, selectedMonth - 1, 1);
            $('#monthPicker').val(selectedYear + '년 ' + selectedMonth.toString().padStart(2, '0') + '월');
            
            calendar.changeView("dayGridMonth");
            calendar.gotoDate(date);
            
            // 모달 닫기
            monthPickerModalInstance.hide();
        });
        
        // 초기 렌더링
        renderMonthGrid();
    }
    
    // 월 선택 input 클릭
    $('#monthPicker').click(function() {
        selectedYear = currentYear;
        selectedMonth = currentMonth;
        
        if(!monthPickerModalInstance) {
            monthPickerModalInstance = new bootstrap.Modal(document.getElementById('monthPickerModal'));
            initMonthPicker();
        }
        
        // 모달 열 때마다 현재 년/월로 재설정
        selectedYear = currentYear;
        selectedMonth = currentMonth;
        $('#yearDisplay').text(selectedYear + '년');
        
        // 월 그리드 다시 렌더링
        const monthNames = ['1월', '2월', '3월', '4월', '5월', '6월', 
                           '7월', '8월', '9월', '10월', '11월', '12월'];
        let html = '';
        for(let i = 0; i < 12; i++) {
            let isSelected = (selectedYear === currentYear && (i + 1) === currentMonth) ? 'selected' : '';
            html += '<div class="month-item ' + isSelected + '" data-month="' + (i + 1) + '">' + 
                    monthNames[i] + '</div>';
        }
        $('#monthGrid').html(html);
        
        monthPickerModalInstance.show();
    });
    
    // ========================================
    // 주 선택 Datepicker (기존 유지)
    // ========================================
    $('#weekPicker').datepicker({
        dateFormat: 'yy-mm-dd',
        changeMonth: true,
        changeYear: true,
        yearRange: '-10:+10',
        onSelect: function(dateText) {
            let date = $(this).datepicker('getDate');
            
            calendar.changeView("listWeek");
            calendar.gotoDate(date);
            
            setTimeout(function() {
                $('#weekPickerBox').show();
                $('#monthPickerBox').hide();
            }, 10);
        }
    });
    
    // 현재 월로 초기화
    let now = new Date();
    let currentMonthText = now.getFullYear() + '년 ' + 
                          (now.getMonth() + 1).toString().padStart(2, '0') + '월';
    $('#monthPicker').val(currentMonthText);
    
});
</script>
<%@ include file ="../include/Footer.jsp"%>