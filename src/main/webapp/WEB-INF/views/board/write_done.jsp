<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><meta charset="UTF-8"><title>등록 완료</title></head>
<body>
  <h2>등록 완료</h2>
  <p>제목: ${post.boardTitle}</p>
  <p>작성자: ${nickname}</p>
  <h3>첨부 이미지</h3>

  <c:if test="${not empty attaches}">
    <c:forEach var="att" items="${attaches}">
      <img src="${att.filePath}" alt="${att.fileName}" style="max-width:400px; margin-bottom:10px;">
    </c:forEach>
  </c:if>

  <c:if test="${empty attaches}">
    <p>첨부된 이미지가 없습니다.</p>
  </c:if>
  <a href="${pageContext.request.contextPath}/board/write">다시 작성</a>
</body>
</html>
