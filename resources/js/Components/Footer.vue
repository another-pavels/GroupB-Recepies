<template>
    <footer class="footer">
        <div class="container">
            <div class="copyright float-right">
                &copy; {{ year }}, FITA DevOps engineer Group B
            </div>
        </div>
    </footer>
</template>

<script>
    export default {
        data() {
            return {
                year: new Date().getFullYear()
            }
        }
    }
</script>
