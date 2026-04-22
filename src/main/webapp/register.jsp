<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register — SahakariNet</title>

<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
body{
    font-family:'Plus Jakarta Sans',sans-serif;
    background:#F1F5F9;
}

/* Typography tuning */
.title-main{
    font-size:30px;
    font-weight:800;
    color:#0F172A;
}
.section-title{
    font-size:12px;
    font-weight:700;
    letter-spacing:0.08em;
    color:#94A3B8;
    text-transform:uppercase;
}
.input-text{
    font-size:14px;
    font-weight:500;
    color:#0F172A;
}
input::placeholder{
    color:#94A3B8;
    font-weight:500;
}
.desc{
    font-size:14px;
    color:#64748B;
}
.btn{
    font-size:15px;
    font-weight:600;
}
.small-text{
    font-size:13px;
    color:#94A3B8;
}
</style>
</head>

<body class="min-h-screen p-4 md:p-12">

<div class="max-w-6xl mx-auto grid md:grid-cols-2 gap-12 items-start">
    
    <!-- LEFT -->
    <div class="space-y-8">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-[#3B82F6] rounded-xl flex items-center justify-center text-white font-bold text-lg shadow-lg">S</div>
            <div>
                <h1 class="text-2xl font-extrabold text-gray-900">
                    Sahakari<span class="text-blue-600">Net</span>
                </h1>
                <p class="text-[11px] text-gray-400 uppercase tracking-widest font-semibold">
                    Cooperative management platform
                </p>
            </div>
        </div>
        
        <p class="desc leading-relaxed">
            Create your member account for Nepal's cooperative management system with a clean, secure, and professional registration experience.
        </p>

        <div class="bg-white p-8 rounded-3xl border border-gray-100 shadow-sm">
            <p class="section-title mb-2">Member registration only</p>
            <h2 class="text-2xl font-extrabold text-gray-900 mb-3">
                Account activates after admin approval
            </h2>
            <p class="desc">
                Every new registration stays pending until the cooperative admin verifies the details and approves the account for access.
            </p>
        </div>

        <div class="space-y-6">
            <div class="flex gap-4">
                <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm">1</div>
                <div>
                    <h4 class="font-semibold text-gray-900 text-sm">
                        Your application is saved with status PENDING
                    </h4>
                    <p class="small-text mt-1">
                        Submit your personal details and account credentials.
                    </p>
                </div>
            </div>

            <div class="flex gap-4">
                <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm">2</div>
                <div>
                    <h4 class="font-semibold text-gray-900 text-sm">
                        The cooperative Admin reviews your application
                    </h4>
                    <p class="small-text mt-1">
                        Your identity and registration information are checked.
                    </p>
                </div>
            </div>

            <div class="flex gap-4">
                <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm">3</div>
                <div>
                    <h4 class="font-semibold text-gray-900 text-sm">
                        Admin approves and your status becomes APPROVED
                    </h4>
                    <p class="small-text mt-1">
                        Once approved, your account is activated.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="bg-white rounded-3xl border border-gray-100 shadow-lg p-8">
        <h2 class="title-main mb-2">Create your account</h2>
        <p class="desc mb-8">
            Member registration only. Account activates after admin approval.
        </p>

        <% if (error != null) { %>
            <div class="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                <%= error %>
            </div>
        <% } %>

        <% if ("true".equals(success)) { %>
            <div class="mb-6 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-700">
                Registration submitted successfully. Your account is pending admin approval.
            </div>
        <% } %>

        <form action="register" method="post" class="space-y-5" onsubmit="return validateForm()">

            <div>
                <h3 class="section-title mb-4">Personal Information</h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <input type="text" name="fullName" placeholder="Full Name *" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-blue-500 outline-none">

                    <input type="date" name="dob" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 text-gray-400 focus:ring-2 focus:ring-blue-500 outline-none">

                    <select name="gender" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 text-gray-400 focus:ring-2 focus:ring-blue-500 outline-none">
                        <option value="" selected disabled>Select gender</option>
                        <option>Male</option><option>Female</option><option>Other</option>
                    </select>

                    <input type="tel" name="phone" placeholder="Phone Number *" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-blue-500 outline-none">
                </div>

                <input type="text" name="citizenshipNo" placeholder="Citizenship No. *" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 mt-4 focus:ring-2 focus:ring-blue-500 outline-none">

                <input type="text" name="address" placeholder="Address *" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 mt-4 focus:ring-2 focus:ring-blue-500 outline-none">
            </div>

            <div>
                <h3 class="section-title mb-4 mt-6">Login Credentials</h3>

                <input type="email" name="email" placeholder="Email" class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-blue-500 outline-none">

                <input type="text" name="username" placeholder="Username *" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 mt-4 focus:ring-2 focus:ring-blue-500 outline-none">

                <div class="grid grid-cols-2 gap-4 mt-4">
                    <input type="password" id="password" name="password" placeholder="Password *" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-blue-500 outline-none">

                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password *" required class="input-text w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-blue-500 outline-none">
                </div>
            </div>

            <button type="submit" class="btn w-full bg-[#3B82F6] hover:bg-blue-700 text-white py-4 rounded-xl transition mt-6">
                Submit Registration
            </button>

            <p class="text-center small-text mt-4">
                Account will be PENDING until Admin approves.
                Already registered?
                <a href="login.jsp" class="text-blue-600 font-semibold hover:underline">Login</a>
            </p>
        </form>
    </div>

</div>

<script>
function validateForm(){
    const p=document.getElementById('password').value;
    const c=document.getElementById('confirmPassword').value;
    if(p!==c){
        alert("Passwords do not match.");
        return false;
    }
    return true;
}
</script>

</body>
</html>