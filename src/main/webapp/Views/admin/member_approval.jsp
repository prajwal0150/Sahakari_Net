<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- FILE: src/main/webapp/views/admin/member-approval.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Member Approvals — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-7xl mx-auto px-6 py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Member Approvals</h1>
            <p class="text-gray-500 text-sm mt-0.5">Review and approve or reject pending member registrations</p>
        </div>

        <c:if test="${param.msg == 'approved'}">
            <div class="bg-green-50 border border-green-200 text-green-800 rounded-xl px-4 py-3 mb-4 text-sm">✅ Member approved and savings account created.</div>
        </c:if>
        <c:if test="${param.msg == 'rejected'}">
            <div class="bg-red-50 border border-red-200 text-red-800 rounded-xl px-4 py-3 mb-4 text-sm">❌ Member registration rejected.</div>
        </c:if>

        <c:choose>
            <c:when test="${empty pending}">
                <div class="bg-white rounded-2xl border border-gray-100 p-16 text-center">
                    <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <p class="text-gray-500 font-semibold">No pending approvals</p>
                    <p class="text-gray-400 text-sm mt-1">All member registrations have been processed.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="space-y-4">
                    <c:forEach var="m" items="${pending}">
                        <div class="bg-white rounded-2xl border border-gray-100 p-6">
                            <div class="flex items-start justify-between gap-4">
                                <div class="flex items-start gap-4">
                                    <div class="w-12 h-12 rounded-2xl bg-amber-100 flex items-center justify-center text-amber-700 font-bold text-lg uppercase flex-shrink-0">
                                            ${m.fullName.substring(0,1)}
                                    </div>
                                    <div>
                                        <h3 class="font-bold text-gray-900">${m.fullName}</h3>
                                        <p class="text-xs text-gray-500 mt-0.5">@${m.username}</p>
                                        <div class="grid grid-cols-2 md:grid-cols-3 gap-x-8 gap-y-1 mt-3">
                                            <div><span class="text-xs text-gray-400">Phone:</span><span class="text-xs font-medium text-gray-700 ml-1">${m.phone}</span></div>
                                            <div><span class="text-xs text-gray-400">Citizenship:</span><span class="text-xs font-mono text-gray-700 ml-1">${m.citizenshipNo}</span></div>
                                            <div><span class="text-xs text-gray-400">Address:</span><span class="text-xs font-medium text-gray-700 ml-1">${m.address}</span></div>
                                            <div><span class="text-xs text-gray-400">DOB:</span><span class="text-xs font-medium text-gray-700 ml-1">${m.dateOfBirth}</span></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex gap-2 flex-shrink-0">
                                    <form action="${pageContext.request.contextPath}/admin" method="post">
                                        <input type="hidden" name="action"   value="approve-member">
                                        <input type="hidden" name="memberId" value="${m.id}">
                                        <button type="submit" class="bg-green-700 text-white text-xs font-semibold px-4 py-2 rounded-xl hover:bg-green-800 transition">✓ Approve</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin" method="post">
                                        <input type="hidden" name="action"   value="reject-member">
                                        <input type="hidden" name="memberId" value="${m.id}">
                                        <button type="submit" class="bg-red-50 text-red-600 border border-red-200 text-xs font-semibold px-4 py-2 rounded-xl hover:bg-red-100 transition">✕ Reject</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div></div>
</body></html>
