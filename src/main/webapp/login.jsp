<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: src/main/webapp/login.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — SahakariNet</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head>
<body class="min-h-screen bg-gradient-to-br from-gray-900 via-green-950 to-gray-900 flex items-center justify-center p-4">

<div class="w-full max-w-md">
    <!-- Logo -->
    <div class="text-center mb-8">
        <a href="index.jsp" class="inline-flex items-center gap-3">
            <div class="w-12 h-12 bg-green-500 rounded-2xl flex items-center justify-center"><span class="text-gray-900 font-extrabold text-xl">S</span></div>
            <span class="text-2xl font-bold text-white">Sahakar<span class="text-green-400">iNet</span></span>
        </a>
        <p class="text-gray-400 text-sm mt-2">Sign in to your account</p>
    </div>

    <!-- Card -->
    <div class="bg-white rounded-3xl shadow-2xl p-8">

        <% if ("true".equals(request.getParameter("logout"))) { %>
        <div class="bg-green-50 border border-green-200 text-green-800 rounded-xl px-4 py-3 mb-5 text-sm flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
            You have been logged out successfully.
        </div>
        <% } %>

        <% if ("success".equals(request.getParameter("reset"))) { %>
        <div class="bg-green-50 border border-green-200 text-green-800 rounded-xl px-4 py-3 mb-5 text-sm flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
            Password reset successful. Please sign in with your new password.
        </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-50 border border-red-200 text-red-800 rounded-xl px-4 py-3 mb-5 text-sm flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <h2 class="text-xl font-bold text-gray-900 mb-6">Welcome back</h2>

        <form action="login" method="post" class="space-y-5">
            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1.5">Username</label>
                <input type="text" name="username" placeholder="Enter your username" required
                       class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent bg-gray-50"
                       value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
            </div>
            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1.5">Password</label>
                <div class="relative">
                    <input type="password" name="password" id="pwd" placeholder="Enter your password" required
                           class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent bg-gray-50 pr-10">
                    <button type="button" onclick="togglePwd()" class="absolute right-3 top-3 text-gray-400 hover:text-gray-600">
                        <svg id="eye-icon" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                    </button>
                </div>
                <div class="mt-2 text-right">
                    <a href="forgot-password" class="text-xs text-green-700 font-semibold hover:underline">Forgot password?</a>
                </div>
            </div>
            <button type="submit" class="w-full bg-green-700 hover:bg-green-800 text-white font-bold py-3 rounded-xl text-sm transition">
                Sign In →
            </button>
        </form>

        <div class="mt-6 pt-6 border-t border-gray-100 text-center">
            <p class="text-sm text-gray-500">Don't have an account?
                <a href="register.jsp" class="text-green-700 font-semibold hover:underline">Register here</a>
            </p>
        </div>

        <!-- Demo accounts -->
        <div class="mt-4 bg-gray-50 rounded-xl p-4">
            <p class="text-xs font-semibold text-gray-400 mb-2 uppercase tracking-wider">Demo Accounts</p>
            <div class="space-y-1 text-xs text-gray-600">
                <div class="flex justify-between"><span>Admin:</span><span class="font-mono">admin / admin123</span></div>
                <div class="flex justify-between"><span>Staff:</span><span class="font-mono">staff1 / staff123</span></div>
                <div class="flex justify-between"><span>Member:</span><span class="font-mono">ashika / member123</span></div>
            </div>
        </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-6"><a href="index.jsp" class="hover:text-white transition">← Back to home</a></p>
</div>

<script>
    function togglePwd() {
        const p = document.getElementById('pwd');
        p.type = p.type === 'password' ? 'text' : 'password';
    }
</script>
</body>
</html>
