<template>
    <Head title="Sākums" />

    <AuthenticatedLayout
        pageTitle="Recepšu saraksts"
        greeting="Skatīties jau gatavs receptes ir lētāk, nekā ražot jaunas!"
        headerBackground="https://ca-times.brightspotcdn.com/dims4/default/8076e3a/2147483647/strip/true/crop/2048x1365+0+0/resize/1200x800!/quality/80/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F96%2F87%2Fd8ac5e4c68e213fbcc77c53f4bfb%2Fla-1549576254-v61sh258hb-snap-image"
        headerFilter="header-filter-extended-classic"
    >
        <DatatableCard
        class="mt-0"
        :columns="[
                {
                    data: 'name',
                    displayName: 'Nosaukums',
                    name: 'recipes.name',
                    linkParams: {
                        name: 'recipes.show',
                        resourceIds: ['id']
                    }
                },
                {
                    data: 'ingredients',
                    displayName: 'Sastāvdaļas',
                    name: 'ingredients.name'
                },
                {
                    data: 'recipe_status',
                    displayName: 'Stāvoklis',
                    name: 'recipes.recipe_status'
                },
                {
                    data: 'user',
                    displayName: 'Pieprasītājs',
                    name: 'users.name',
                },
            ]"
            :order="[
                {
                    column: 0,
                    dir: 'desc',
                }
            ]"
            :url="route('recipes.datatable')"
        />
    </AuthenticatedLayout>
</template>

<script>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';
import DatatableCard from '@/Components/DatatableCard.vue';

    export default {
        components: {
            AuthenticatedLayout,
            Head,
            DatatableCard
        },
        data: () => ({
        }),
        computed: {
        }
    }
</script>
