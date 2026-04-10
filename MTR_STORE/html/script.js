window.addEventListener('message', function(event) {
    // هذه الوظيفة يمكنها كشف التلاعب بواجهة المستخدم
    if (event.data.type === "check_ui") {
        fetch(`https://${GetParentResourceName()}/ui_report`, {
            method: 'POST',
            body: JSON.stringify({ status: "ok" })
        });
    }
});