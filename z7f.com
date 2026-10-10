
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Taki Kali Web Lab</title>
<style>
*{box-sizing:border-box}
body{margin:0;background:#07121f;color:#e5f1ff;font-family:Arial,Tahoma,sans-serif}
header{height:52px;background:#101d2b;border-bottom:1px solid #30445b;display:flex;align-items:center;justify-content:space-between;padding:0 16px}
.brand{font-weight:bold;color:#69c9ff}
.desktop{min-height:calc(100vh - 90px);padding:24px;background:radial-gradient(ellipse at top left,#17436a,#091827 55%,#050c16)}
h1{font-size:26px;margin:0 0 8px}
.subtitle{color:#afc4dc;font-size:14px;margin-bottom:25px}
.apps{display:grid;grid-template-columns:repeat(auto-fit,minmax(135px,1fr));gap:14px;max-width:850px}
.app{border:1px solid #29445f;background:#0c1c2d;border-radius:12px;padding:18px 12px;color:white;cursor:pointer;text-align:center;font:inherit}
.app:hover{border-color:#51c4ff;background:#132b42}
.emoji{font-size:30px;display:block;margin-bottom:10px}
.window{max-width:850px;margin:25px auto 0;border:1px solid #35516b;border-radius:12px;overflow:hidden;background:#050b12;box-shadow:0 12px 35px #0008}
.wtitle{background:#18283a;padding:11px 14px;display:flex;justify-content:space-between;gap:8px}
.wtitle button{width:auto;padding:3px 9px}
#terminal{padding:16px;height:260px;overflow:auto;white-space:pre-wrap;overflow-wrap:anywhere;color:#c4f4d6;font:14px/1.7 Consolas,monospace}
.prompt{display:flex;gap:8px;padding:10px;border-top:1px solid #203449}
.prompt span{color:#6cf0ac;font:14px Consolas,monospace;padding-top:10px}
input,textarea,select{width:100%;background:#07121f;color:white;border:1px solid #36516b;border-radius:7px;padding:11px;font:14px Arial}
.prompt input{border:0;outline:none;font-family:Consolas,monospace}
button,.btn{background:#147fb0;border:0;border-radius:7px;padding:10px 13px;color:white;cursor:pointer;font:inherit}
button:hover,.btn:hover{background:#199dd9}
.panel{display:none;max-width:850px;margin:20px auto;background:#0c1c2d;border:1px solid #29445f;border-radius:12px;padding:20px}
.panel h2{margin-top:0;color:#72d1ff}
.panel button{margin-top:10px}
.result{white-space:pre-wrap;overflow-wrap:anywhere;background:#050b12;border-radius:8px;padding:12px;margin-top:14px;min-height:35px;line-height:1.7}
.note{color:#a9bfd6;font-size:13px;line-height:1.7}
footer{padding:15px;text-align:center;background:#101d2b;color:#a9bfd6;font-size:12px}
@media(max-width:500px){.desktop{padding:16px}.apps{grid-template-columns:repeat(2,minmax(0,1fr))}}
</style>
</head>
<body>
<header>
  <span class="brand">🐉 TAKI KALI WEB LAB</span>
  <span id="clock">Web Security Lab</span>
</header>

<main class="desktop">
  <h1>مرحبًا بك في المختبر الأمني</h1>
  <div class="subtitle">بيئة تعليمية داخل المتصفح — لا تحتاج إلى تثبيت برامج</div>

  <div class="apps">
    <button class="app" onclick="showPanel('terminalPanel')">
      <span class="emoji">⌨️</span>Terminal
    </button>
    <button class="app" onclick="showPanel('urlPanel')">
      <span class="emoji">🛡️</span>فحص الروابط
    </button>
    <button class="app" onclick="showPanel('hashPanel')">
      <span class="emoji">🔐</span>SHA-256
    </button>
    <button class="app" onclick="showPanel('basePanel')">
      <span class="emoji">🔄</span>Base64
    </button>
    <button class="app" onclick="showPanel('passwordPanel')">
      <span class="emoji">🔑</span>مولّد كلمات المرور
    </button>
    <button class="app" onclick="showPanel('aboutPanel')">
      <span class="emoji">ℹ️</span>حول المختبر
    </button>
  </div>

  <section class="window" id="terminalPanel">
    <div class="wtitle">
      <span>Terminal — Web Lab</span>
      <button onclick="clearTerminal()">مسح</button>
    </div>
    <div id="terminal">TAKI KALI WEB LAB
هذه محاكاة أوامر وليست نظام Linux حقيقيًا.
اكتب help لعرض الأوامر المتاحة.

</div>
    <form class="prompt" id="termForm">
      <span>taki@lab:~$</span>
      <input id="command" autocomplete="off" placeholder="اكتب help ثم Enter">
    </form>
  </section>

  <section class="panel" id="urlPanel">
    <h2>🛡️ فاحص الروابط</h2>
    <p class="note">يفحص صيغة الرابط وبعض العلامات المحلية. لا يفتح الرابط ولا يرسل عنوانه لأي خدمة خارجية.</p>
    <input id="urlInput" placeholder="https://example.com">
    <button onclick="checkURL()">فحص الرابط</button>
    <div class="result" id="urlResult">النتيجة تظهر هنا.</div>
  </section>

  <section class="panel" id="hashPanel">
    <h2>🔐 حساب SHA-256</h2>
    <p class="note">تحويل النص إلى بصمة SHA-256 باستخدام واجهة التشفير في المتصفح.</p>
    <textarea id="hashInput" placeholder="اكتب النص المراد حساب بصمته"></textarea>
    <button onclick="makeHash()">احسب البصمة</button>
    <div class="result" id="hashResult"></div>
  </section>

  <section class="panel" id="basePanel">
    <h2>🔄 أداة Base64</h2>
    <textarea id="baseInput" placeholder="اكتب النص هنا"></textarea>
    <button onclick="baseEncode()">ترميز النص</button>
    <button onclick="baseDecode()">فك الترميز</button>
    <div class="result" id="baseResult"></div>
    <p class="note">Base64 ليس تشفيرًا آمنًا ولا يحمي الأسرار.</p>
  </section>

  <section class="panel" id="passwordPanel">
    <h2>🔑 مولّد كلمات المرور</h2>
    <label>الطول (8 إلى 64)</label>
    <input type="number" id="passLength" value="20" min="8" max="64">
    <button onclick="generatePassword()">توليد كلمة مرور</button>
    <div class="result" id="passResult"></div>
    <button onclick="copyPassword()">نسخ النتيجة</button>
  </section>

  <section class="panel" id="aboutPanel">
    <h2>حول المشروع</h2>
    <p>TAKI KALI WEB LAB هو مختبر تعليمي يعمل في المتصفح.</p>
    <p>الأدوات المنفذة محليًا: تحليل صيغة الروابط، SHA-256، Base64 وتوليد كلمات مرور عشوائية.</p>
    <p class="note">الطرفية محاكاة وليست Bash. لا يوجد هنا فحص منافذ أو اختراق شبكات أو تشغيل أوامر نظام حقيقية.</p>
  </section>
</main>

<footer>TAKI KALI WEB LAB · مشروع تعليمي للأمن السيبراني</footer>

<script>
function showPanel(id){
  document.querySelectorAll('.panel').forEach(function(p){p.style.display='none'});
  if(id!=='terminalPanel')document.getElementById(id).style.display='block';
  if(id==='terminalPanel')document.getElementById(id).scrollIntoView({behavior:'smooth',block:'nearest'});
}
function say(text){
  var t=document.getElementById('terminal');
  t.textContent+=text+'\n';
  t.scrollTop=t.scrollHeight;
}
function clearTerminal(){document.getElementById('terminal').textContent='';}
document.getElementById('termForm').addEventListener('submit',function(e){
  e.preventDefault();
  var el=document.getElementById('command');
  var cmd=el.value.trim();
  if(!cmd)return;
  say('taki@lab:~$ '+cmd);
  el.value='';
  var args=cmd.split(/\s+/);
  switch(args[0].toLowerCase()){
    case 'help':
      say('الأوامر المتاحة:\nhelp       عرض المساعدة\nclear      مسح الطرفية\nwhoami     اسم المستخدم التجريبي\npwd        مسار افتراضي\nls         قائمة ملفات افتراضية\ndate       الوقت الحالي\nurlcheck <رابط> فحص محلي\nsha256 <نص> حساب البصمة\nbase64 <نص> ترميز النص\nabout      معلومات المختبر');
      break;
    case 'clear':clearTerminal();break;
    case 'whoami':say('taki-web-lab (اسم تجريبي)');break;
    case 'pwd':say('/home/taki (مسار افتراضي)');break;
    case 'ls':say('Documents  Downloads  security-lab  notes.txt (قائمة افتراضية)');break;
    case 'date':say(new Date().toString());break;
    case 'about':say('مختبر ويب تعليمي. الأوامر هنا محاكاة، ما عدا الأدوات التي تنفذها واجهات المختبر فعليًا.');break;
    case 'urlcheck':
      if(args.length<2){say('الاستعمال: urlcheck https://example.com');break;}
      document.getElementById('urlInput').value=args[1];
      showPanel('urlPanel');checkURL();say('تم تشغيل فحص صيغة الرابط في أداة المختبر.');
      break;
    case 'sha256':
      if(!cmd.slice(7).trim()){say('الاستعمال: sha256 hello');break;}
      document.getElementById('hashInput').value=cmd.slice(7);
      showPanel('hashPanel');makeHash();say('تم طلب حساب SHA-256.');
      break;
    case 'base64':
      if(!cmd.slice(7).trim()){say('الاستعمال: base64 hello');break;}
      document.getElementById('baseInput').value=cmd.slice(7);
      showPanel('basePanel');baseEncode();say('تم ترميز النص في أداة Base64.');
      break;
    default:say('أمر غير معروف. اكتب help. هذه الطرفية لا تنفّذ أوامر نظام التشغيل.');
  }
});
function checkURL(){
  var v=document.getElementById('urlInput').value.trim();
  var out=document.getElementById('urlResult');
  var issues=[];
  if(!v){out.textContent='اكتب رابطًا أولًا.';return;}
  var u;
  try{u=new URL(v)}catch(e){out.textContent='⚠️ صيغة الرابط غير صالحة.';return;}
  if(u.protocol!=='https:'&&u.protocol!=='http:')issues.push('بروتوكول غير متوقع.');
  if(u.protocol==='http:')issues.push('الاتصال لا يستخدم HTTPS.');
  if(u.username||u.password)issues.push('يحتوي على بيانات قبل اسم النطاق.');
  if(/^\d{1,3}(\.\d{1,3}){3}$/.test(u.hostname))issues.push('يستخدم عنوان IP بدل اسم نطاق.');
  if(u.hostname.includes('xn--'))issues.push('يحتوي على اسم نطاق مرمّز قد يحتاج إلى تحقق.');
  if(u.hostname.length>60)issues.push('اسم النطاق طويل بشكل غير معتاد.');
  if(/%[0-9a-f]{2}/i.test(u.pathname))issues.push('مسار الرابط يحتوي على ترميز.');
  out.textContent=(issues.length?'⚠️ علامات تستحق الحذر:\n• '+issues.join('\n• '):'لم تظهر العلامات البسيطة التي تفحصها الأداة.')+
    '\n\nاسم النطاق: '+u.hostname+'\n\nتنبيه: النتيجة ليست حكمًا على سلامة الرابط، ولا يتم فحص سمعة الموقع أو محتواه.';
}
async function makeHash(){
  var out=document.getElementById('hashResult');
  try{
    if(!window.crypto||!crypto.subtle)throw new Error('Crypto API غير متاح في هذا المتصفح.');
    var bytes=new TextEncoder().encode(document.getElementById('hashInput').value);
    var digest=await crypto.subtle.digest('SHA-256',bytes);
    out.textContent=Array.from(new Uint8Array(digest)).map(function(b){return b.toString(16).padStart(2,'0')}).join('');
  }catch(e){out.textContent='تعذر حساب البصمة: '+e.message+' جرّب متصفحًا أحدث.';}
}
function baseEncode(){
  try{
    var bytes=new TextEncoder().encode(document.getElementById('baseInput').value);
    var binary=Array.from(bytes).map(function(b){return String.fromCharCode(b)}).join('');
    document.getElementById('baseResult').textContent=btoa(binary);
  }catch(e){document.getElementById('baseResult').textContent='تعذر الترميز.';}
}
function baseDecode(){
  try{
    var binary=atob(document.getElementById('baseInput').value.trim());
    var bytes=Uint8Array.from(binary,function(c){return c.charCodeAt(0)});
    document.getElementById('baseResult').textContent=new TextDecoder('utf-8',{fatal:true}).decode(bytes);
  }catch(e){document.getElementById('baseResult').textContent='النص ليس Base64 صالحًا أو أن الترميز غير مدعوم.';}
}
function generatePassword(){
  var n=Number(document.getElementById('passLength').value);
  if(!Number.isInteger(n)||n<8||n>64){document.getElementById('passResult').textContent='اختر طولًا من 8 إلى 64.';return;}
  var chars='ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%*-_';
  var out='';
  var bytes=new Uint8Array(n);
  if(!crypto||!crypto.getRandomValues){document.getElementById('passResult').textContent='مولّد الأرقام الآمنة غير متاح في هذا المتصفح.';return;}
  crypto.getRandomValues(bytes);
  for(var i=0;i<n;i++)out+=chars[bytes[i]%chars.length];
  document.getElementById('passResult').textContent=out;
}
function copyPassword(){
  var text=document.getElementById('passResult').textContent;
  if(navigator.clipboard&&location.protocol==='https:'){
    navigator.clipboard.writeText(text).then(function(){alert('تم النسخ')}).catch(function(){alert('النسخ التلقائي غير متاح؛ انسخ النص يدويًا.')});
  }else{alert('انسخ كلمة المرور يدويًا من النتيجة.');}
}
function updateClock(){
  document.getElementById('clock').textContent=new Date().toLocaleTimeString();
}
updateClock();setInterval(updateClock,1000);
</script>
</body>
</html>
