<script setup>
import NavLink from '@/Components/NavLink.vue';
import NavItem from './NavItem.vue';
</script>

<template>
    <ul class="ml-auto navbar-nav">
        <NavItem
            v-for="(item, index) in items"
            :key="index"
            :title="item.title"
            :icon="item.icon"
            :routeName="item.routeName"
            :subItems="item.subItems"
        />
</ul>
</template>

<script>
    export default {
        data() {
            return {
                items: [
                    {
                        title: 'Sākums',
                        icon: 'home',
                        routeName: 'home',
                    },
                    {
                        title: 'Receptes',
                        icon: 'menu_book',
                        routeName: 'recipes.index',
                    },
                    {
                        title: 'Iziet',
                        icon: 'logout',
                        routeName: 'logout',
                    },
                ]
            }
        },
    }
</script>
