<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FILE: src/main/webapp/views/admin/member-detail.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Member Detail — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-4xl mx-auto px-6 py-8">
        <a href="${pageContext.request.contextPath}/admin?page=members" class="inline-flex items-center gap-1 text-xs text-gray-500 hover:text-gray-700 mb-6">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
            Back to Members
        </a>
        <c:if test="${member != null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-7">
                <div class="flex items-center gap-4 mb-6">
                    <div class="w-16 h-16 rounded-2xl bg-green-100 flex items-center justify-center text-green-700 font-extrabold text-2xl uppercase">${member.fullName.substring(0,1)}</div>
                    <div>
                        <h1 class="text-xl font-bold text-gray-900">${member.fullName}</h1>
                        <p class="text-gray-500 text-sm">@${member.username}</p>
                        <c:choose>
                            <c:when test="${member.status == 'APPROVED'}"><span class="inline-block bg-green-100 text-green-700 text-xs font-bold px-2.5 py-1 rounded-full mt-1">APPROVED</span></c:when>
                            <c:when test="${member.status == 'PENDING'}"> <span class="inline-block bg-amber-100 text-amber-700 text-xs font-bold px-2.5 py-1 rounded-full mt-1">PENDING</span></c:when>
                            <c:otherwise>                                 <span class="inline-block bg-red-100 text-red-600 text-xs font-bold px-2.5 py-1 rounded-full mt-1">REJECTED</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                    <div><p class="text-xs text-gray-400">Phone</p><p class="text-sm font-semibold text-gray-800 mt-0.5">${member.phone}</p></div>
                    <div><p class="text-xs text-gray-400">Address</p><p class="text-sm font-semibold text-gray-800 mt-0.5">${member.address}</p></div>
                    <div><p class="text-xs text-gray-400">Citizenship No.</p><p class="text-sm font-mono font-semibold text-gray-800 mt-0.5">${member.citizenshipNo}</p></div>
                    <div><p class="text-xs text-gray-400">Date of Birth</p><p class="text-sm font-semibold text-gray-800 mt-0.5">${member.dateOfBirth}</p></div>
                    <div><p class="text-xs text-gray-400">Member Since</p><p class="text-sm font-semibold text-gray-800 mt-0.5">${member.joinedDate}</p></div>
                </div>
            </div>
        </c:if>
    </div></div>
</body></html>
