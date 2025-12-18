<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/Header.jsp"%>
<div id="subContents" class="alignCenter">
    <div class="fix-layout ai-chat-page">
        <!-- 헤더 -->
        <div class="chat-header">
            <h1 class="page-title mb20">AI 금융비서 센스봇</h1>
            <p class="page-sub-title">무엇이든 물어보세요! 소비 패턴, 지출 내역 등을 분석해드립니다.</p>
        </div>
        
        <!-- 채팅 컨테이너 -->
        <div class="chat-container">
            <!-- 대화 이력 -->
            <div class="chat-history">
                <h3>최근 대화<a href="#" class="fold-btn"></a></h3>
                <c:choose>
                    <c:when test="${not empty chatHistory}">
                    	<div class="history-wrap">
                        <c:forEach var="chat" items="${chatHistory}">
                            <div class="history-item" data-question="${chat.question}" data-answer="${chat.answer}">
                                <div class="history-question">${chat.question}</div>
                                <div class="history-time">
                                    <fmt:formatDate value="${chat.createdAt}" pattern="MM/dd HH:mm"/>
                                </div>
                            </div>
                        </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align:center; color:#999; padding:20px 0; font-size:13px;">
                            아직 대화 이력이 없습니다
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- 메인 채팅 -->
            <div class="chat-main">
                <div class="chat-messages" id="chatMessages">
                    <!-- 빈 상태 -->
                    <div class="empty-chat" id="emptyChat">
                        <div class="empty-chat-icon">🤖</div>
                        <div class="empty-chat-text">안녕하세요! 무엇을 도와드릴까요?</div>
                        <div class="empty-chat-subtext">아래 질문을 클릭하거나 직접 입력해보세요</div>
                        <div class="suggestion-chips">
                            <div class="suggestion-chip" data-question="이번 달 어디서 돈을 많이 썼어?">이번 달 어디서 돈을 많이 썼어?</div>
                            <div class="suggestion-chip" data-question="내가 가장 많이 쓰는 카테고리는 뭐야?">내가 가장 많이 쓰는 카테고리는?</div>
                            <div class="suggestion-chip" data-question="지난달 대비 지출이 어떻게 변했어?">지난달 대비 지출 변화는?</div>
                            <div class="suggestion-chip" data-question="이번 달 카페에서 얼마 썼어?">이번 달 카페 지출은?</div>
                        </div>
                    </div>
                </div>
                
                <!-- 입력 영역 -->
                <div class="chat-input-area">
                    <div class="chat-input-wrapper">
                        <textarea id="chatInput" placeholder="질문을 입력하세요..." rows="2"></textarea>
                        <button id="sendBtn" type="button">전송</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    
    const csrfToken = '${_csrf.token}';
    const csrfHeader = '${_csrf.headerName}';
    
    let isProcessing = false;
    
    // 메시지 추가
    function addMessage(type, content) {
        const emptyChat = $('#emptyChat');
        if (emptyChat.length > 0) {
            emptyChat.remove();
        }
        
        const now = new Date();
        const timeStr = now.getHours().toString().padStart(2, '0') + ':' + 
                       now.getMinutes().toString().padStart(2, '0');
        
        const avatar = type === 'user' ? '👤' : '🤖';
        
        const messageHtml = 
            '<div class="message ' + type + '">' +
                '<div class="message-avatar">' + avatar + '</div>' +
                '<div>' +
                    '<div class="message-content">' + content + '</div>' +
                    '<div class="message-time">' + timeStr + '</div>' +
                '</div>' +
            '</div>';
        
        $('#chatMessages').append(messageHtml);
        scrollToBottom();
    }
    
    // 로딩 인디케이터
    function addLoadingIndicator() {
        const loadingHtml = 
            '<div class="message assistant" id="loadingMessage">' +
                '<div class="message-avatar">🤖</div>' +
                '<div class="message-content loading-indicator">' +
                    '<div class="loading-dot"></div>' +
                    '<div class="loading-dot"></div>' +
                    '<div class="loading-dot"></div>' +
                '</div>' +
            '</div>';
        
        $('#chatMessages').append(loadingHtml);
        scrollToBottom();
    }
    
    function removeLoadingIndicator() {
        $('#loadingMessage').remove();
    }
    
    // 스크롤 하단으로
    function scrollToBottom() {
        const chatMessages = $('#chatMessages');
        chatMessages.scrollTop(chatMessages[0].scrollHeight);
    }
    
    // 메시지 전송
    function sendMessage(question) {
        if (!question || question.trim() === '' || isProcessing) {
            return;
        }
        
        isProcessing = true;
        $('#sendBtn').prop('disabled', true);
        $('#chatInput').prop('disabled', true);
        
        // 사용자 메시지 추가
        addMessage('user', question);
        
        // 로딩 인디케이터
        addLoadingIndicator();
        
        // AJAX 요청
        $.ajax({
            url: '${ctx}/ai/chat',
            type: 'POST',
            data: {
                question: question
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            success: function(response) {
                removeLoadingIndicator();
                
                if (response.success) {
                    addMessage('assistant', response.answer);
                } else {
                    addMessage('assistant', '죄송합니다. 응답 중 오류가 발생했습니다.');
                }
            },
            error: function(xhr, status, error) {
                console.error('채팅 오류:', error);
                removeLoadingIndicator();
                addMessage('assistant', '네트워크 오류가 발생했습니다. 다시 시도해주세요.');
            },
            complete: function() {
                isProcessing = false;
                $('#sendBtn').prop('disabled', false);
                $('#chatInput').prop('disabled', false);
                $('#chatInput').val('').focus();
            }
        });
    }
    
    // 전송 버튼 클릭
    $('#sendBtn').click(function() {
        const question = $('#chatInput').val().trim();
        sendMessage(question);
    });
    
    // Enter 키 전송 (Shift+Enter는 줄바꿈)
    $('#chatInput').keydown(function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            const question = $(this).val().trim();
            sendMessage(question);
        }
    });
    
    // 제안 칩 클릭
    $(document).on('click', '.suggestion-chip', function() {
        const question = $(this).data('question');
        sendMessage(question);
    });
    
    // 이력 클릭
    $('.history-item').click(function() {
        const question = $(this).data('question');
        const answer = $(this).data('answer');
        
        // 빈 상태 제거
        $('#emptyChat').remove();
        
        // 메시지 추가
        addMessage('user', question);
        addMessage('assistant', answer);
    });
    
    $('.fold-btn').click(function(){
    	$(this).toggleClass('active');
    	$('.history-wrap').toggleClass('fold');
    });
    
});
</script>

<%@ include file="../include/Fixed.jsp"%>