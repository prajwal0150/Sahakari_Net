<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: src/main/webapp/register.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — SahakariNet</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head>
<body class="min-h-screen bg-gradient-to-br from-gray-50 via-white to-emerald-50 py-10 px-4">

<div class="max-w-3xl mx-auto">
    <!-- Header -->
    <div class="text-center mb-8">
        <a href="index.jsp" class="inline-flex items-center gap-2 mb-4">
            <div class="w-9 h-9 bg-green-700 rounded-xl flex items-center justify-center"><span class="text-white font-bold">S</span></div>
            <span class="text-xl font-bold text-gray-900">Sahakar<span class="text-green-700">iNet</span></span>
        </a>
        <h1 class="text-2xl font-bold text-gray-900">Create your account</h1>
        <p class="text-gray-500 text-sm mt-1">Member registration only. Account activates after admin approval.</p>
    </div>

    <% if ("true".equals(request.getParameter("success"))) { %>
    <div class="bg-green-50 border border-green-200 text-green-800 rounded-2xl p-5 mb-6">
        <div class="flex items-start gap-3">
            <svg class="w-5 h-5 text-green-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <div>
                <p class="font-semibold text-sm">Registration submitted successfully!</p>
                <p class="text-sm mt-1">Your application is <strong>pending approval</strong> by the Admin. You will receive access once approved. <a href="login.jsp" class="underline font-semibold">Go to login</a></p>
            </div>
        </div>
    </div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
    <div class="bg-red-50 border border-red-200 text-red-800 rounded-2xl px-5 py-4 mb-6 text-sm flex items-center gap-2">
        <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="bg-white rounded-3xl border border-gray-100 shadow-lg p-6 md:p-8">
        <form action="register" method="post" class="space-y-5" onsubmit="return validateForm()">

            <div class="pb-2 border-b border-gray-100">
                <h3 class="text-xs font-bold text-gray-400 uppercase tracking-widest">Personal Information</h3>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">Full Name <span class="text-red-500">*</span></label>
                    <input type="text" name="fullName" placeholder="name" required
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50"
                           value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">Date of Birth <span class="text-red-500">*</span></label>
                    <input type="date" name="dob" required
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">Gender <span class="text-red-500">*</span></label>
                    <select name="gender" required class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                        <option value="">Select gender</option>
                        <option value="Male" <%= "Male".equalsIgnoreCase(request.getParameter("gender")) ? "selected" : "" %>>Male</option>
                        <option value="Female" <%= "Female".equalsIgnoreCase(request.getParameter("gender")) ? "selected" : "" %>>Female</option>
                        <option value="Other" <%= "Other".equalsIgnoreCase(request.getParameter("gender")) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">Phone Number <span class="text-red-500">*</span></label>
                    <input type="tel" name="phone" placeholder="98XXXXXXXX" required maxlength="10"
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50"
                           value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">Citizenship No. <span class="text-red-500">*</span></label>
                    <input type="text" name="citizenshipNo" placeholder="e.g. 12-345-6789" required
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50"
                           value="<%= request.getParameter("citizenshipNo") != null ? request.getParameter("citizenshipNo") : "" %>">
                </div>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1.5">Address <span class="text-red-500">*</span></label>
                <input type="text" name="address" placeholder="District, Municipality / Gaunpalika" required
                       class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50"
                       value="<%= request.getParameter("address") != null ? request.getParameter("address") : "" %>">
            </div>

            <div class="pb-2 border-b border-gray-100 pt-2">
                <h3 class="text-xs font-bold text-gray-400 uppercase tracking-widest">Login Credentials</h3>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1.5">Email</label>
                <input type="email" name="email" placeholder="your@email.com"
                       class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50"
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">Username <span class="text-red-500">*</span></label>
                    <input type="text" name="username" placeholder="Choose a username" required
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50"
                           value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">Password <span class="text-red-500">*</span></label>
                    <input type="password" name="password" id="password" placeholder="Min. 6 characters" required minlength="6"
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">Confirm Password <span class="text-red-500">*</span></label>
                    <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Re-enter password" required
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                    <p id="pwdError" class="text-xs text-red-500 mt-1 hidden">Passwords do not match.</p>
                </div>
            </div>

            <button type="submit" class="w-full bg-green-700 hover:bg-green-800 text-white font-bold py-3.5 rounded-xl text-sm transition mt-2">
                Submit Registration
            </button>

            <p class="text-center text-xs text-gray-400">
                Account will be <strong class="text-amber-600">PENDING</strong> until Admin approves. Already registered? <a href="login.jsp" class="text-green-700 font-semibold hover:underline">Login</a>
            </p>
        </form>
    </div>

    <!-- What happens next -->
    <div class="mt-6 bg-blue-50 border border-blue-100 rounded-2xl p-5 text-sm text-blue-800">
        <p class="font-semibold mb-2">What happens after you register?</p>
        <ol class="list-decimal list-inside space-y-1 text-blue-700 text-xs">
            <li>Your application is saved with status <strong>PENDING</strong></li>
            <li>The cooperative Admin reviews your application</li>
            <li>Admin approves → your status becomes <strong>APPROVED</strong></li>
            <li>You can now login and access your member dashboard</li>
        </ol>
    </div>
</div>

<script>
    function validateForm() {
        const p = document.getElementById('password').value;
        const c = document.getElementById('confirmPassword').value;
        const err = document.getElementById('pwdError');
        if (p !== c) { err.classList.remove('hidden'); return false; }
        err.classList.add('hidden'); return true;
    }
</script>
</body>
</html>
