<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/Header.jsp"%>
<style>
.ai-chat-page {width:100%; max-width:1200px; margin:0 auto; padding:20px;}
.ai-chat-page .chat-header {background:#fff; padding:20px; border-radius:8px; margin-bottom:20px; box-shadow:0 2px 4px rgba(0,0,0,0.1);}
.ai-chat-page .chat-header h2 {margin:0 0 10px 0; font-size:24px; color:#333;}
.ai-chat-page .chat-header p {margin:0; color:#666; font-size:14px;}
.ai-chat-page .chat-container {display:flex; gap:20px;}
.ai-chat-page .chat-history {flex:0 0 280px; background:#fff; border-radius:8px; padding:20px; box-shadow:0 2px 4px rgba(0,0,0,0.1); max-height:600px; overflow-y:auto;}
.ai-chat-page .chat-history h3 {margin:0 0 15px 0; font-size:16px; color:#333; padding-bottom:10px; border-bottom:2px solid #f0f0f0;}
.ai-chat-page .history-item {padding:12px; margin-bottom:10px; border-radius:6px; background:#f8f9fa; cursor:pointer; transition:all 0.2s;}
.ai-chat-page .history-item:hover {background:#e9ecef;}
.ai-chat-page .history-item .history-question {font-size:13px; color:#333; margin-bottom:5px; font-weight:500; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;}
.ai-chat-page .history-item .history-time {font-size:11px; color:#999;}
.ai-chat-page .chat-main {flex:1; background:#fff; border-radius:8px; box-shadow:0 2px 4px rgba(0,0,0,0.1); display:flex; flex-direction:column; height:600px;}
.ai-chat-page .chat-messages {flex:1; padding:20px; overflow-y:auto; display:flex; flex-direction:column; gap:15px;}
.ai-chat-page .message {display:flex; gap:10px; max-width:80%; padding:0; background:none; border:0;}
.ai-chat-page .message.user {margin-left:auto; flex-direction:row-reverse;}
.ai-chat-page .message-avatar {width:36px; height:36px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:18px; flex-shrink:0;}
.ai-chat-page .message.user .message-avatar {background:#00AEEE; color:#fff;}
.ai-chat-page .message.assistant .message-avatar {background:#7B838D; color:#fff;}
.ai-chat-page .message-content {flex:1; padding:12px 16px; border-radius:12px; font-size:14px; line-height:1.6;}
.ai-chat-page .message.user .message-content {background:#00AEEE; color:#fff; border-bottom-right-radius:4px;}
.ai-chat-page .message.assistant .message-content {background:#f0f0f0; color:#333; border-bottom-left-radius:4px;}
.ai-chat-page .message-time {font-size:11px; color:#999; margin-top:4px;}
.ai-chat-page .chat-input-area {padding:20px; border-top:1px solid #e9ecef;}
.ai-chat-page .chat-input-wrapper {display:flex; gap:10px;}
.ai-chat-page .chat-input-wrapper textarea {flex:1; padding:12px; border:1px solid #ddd; border-radius:8px; resize:none; font-size:14px; font-family:inherit;}
.ai-chat-page .chat-input-wrapper textarea:focus {outline:none; border-color:#00AEEE;}
.ai-chat-page .chat-input-wrapper button {padding:12px 24px; background:#00AEEE; color:#fff; border:none; border-radius:8px; cursor:pointer; font-size:14px; font-weight:500; transition:all 0.2s;}
.ai-chat-page .chat-input-wrapper button:hover {background:#0099d4;}
.ai-chat-page .chat-input-wrapper button:disabled {background:#ccc; cursor:not-allowed;}
.ai-chat-page .empty-chat {flex:1; display:flex; flex-direction:column; align-items:center; justify-content:center; color:#999;}
.ai-chat-page .empty-chat-icon {font-size:48px; margin-bottom:15px; opacity:0.5;}
.ai-chat-page .empty-chat-text {font-size:16px; margin-bottom:10px;}
.ai-chat-page .empty-chat-subtext {font-size:13px;}
.ai-chat-page .suggestion-chips {display:flex; flex-wrap:wrap; gap:8px; margin-top:20px;}
.ai-chat-page .suggestion-chip {padding:8px 16px; background:#f0f0f0; border:1px solid #ddd; border-radius:20px; font-size:13px; color:#666; cursor:pointer; transition:all 0.2s;}
.ai-chat-page .suggestion-chip:hover {background:#e0e0e0; border-color:#ccc;}
.ai-chat-page .loading-indicator {display:flex; gap:5px; padding:12px 16px;}
.ai-chat-page .loading-dot {width:8px; height:8px; background:#999; border-radius:50%; animation:bounce 1.4s infinite ease-in-out both;}
.ai-chat-page .loading-dot:nth-child(1) {animation-delay:-0.32s;}
.ai-chat-page .loading-dot:nth-child(2) {animation-delay:-0.16s;}
@keyframes bounce {0%, 80%, 100% {transform:scale(0);} 40% {transform:scale(1);}}
</style>

<div id="subContents">
    <div class="fix-layout ai-chat-page">
        <!-- 헤더 -->
        <div class="chat-header">
            <h2>💬 AI 금융 어시스턴트</h2>
            <p>무엇이든 물어보세요! 소비 패턴, 지출 내역 등을 분석해드립니다.</p>
        </div>
        
        <!-- 채팅 컨테이너 -->
        <div class="chat-container">
            <!-- 대화 이력 -->
            <div class="chat-history">
                <h3>최근 대화</h3>
                <c:choose>
                    <c:when test="${not empty chatHistory}">
                        <c:forEach var="chat" items="${chatHistory}">
                            <div class="history-item" data-question="${chat.question}" data-answer="${chat.answer}">
                                <div class="history-question">${chat.question}</div>
                                <div class="history-time">
                                    <fmt:formatDate value="${chat.createdAt}" pattern="MM/dd HH:mm"/>
                                </div>
                            </div>
                        </c:forEach>
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
    
});
</script>

<%@ include file="../include/Fixed.jsp"%>