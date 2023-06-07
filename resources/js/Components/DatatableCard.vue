<template>
    <div class="card" :class="cardClasses">
        <header class="card-heading">
            <div class="card-search" :class="{open:searchBarOpen}">
                <div class="form-group label-floating is-empty">
                    <i class="material-icons search-icon-left">search</i>
                    <input type="text" class="form-control filter-input" placeholder="Search..." autocomplete="off" @keyup="setSearchTerm">
                    <a href="javascript:void(0)" class="close-search" @click="clearSearch" data-tippy-content="Close">
                        <i class="material-icons">close</i>
                    </a>
                </div>
            </div>
            <ul class="card-actions icons right-top">
                    <li v-if="createLink">
                        <Link  :href="createLink" data-tippy-content="Create new">
                            <i class="material-icons">add</i>
                        </Link>
                    </li>
                <li>
                    <a href="javascript:void(0)" data-tippy-content="Meklēt" @click="searchBarOpen = true">
                        <i class="material-icons">search</i>
                    </a>
                </li>
                <li class="dropdown" data-tippy-content="Show Entries">
                    <a href="javascript:void(0)" data-bs-toggle="dropdown">
                        <i class="material-icons">more_vert</i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-right">
                        <li @click="setPageLength(10)">
                            <a href="javascript:void(0)">10</a>
                        </li>
                        <li @click="setPageLength(25)">
                            <a href="javascript:void(0)">25</a>
                        </li>
                        <li @click="setPageLength(50)">
                            <a href="javascript:void(0)">50</a>
                        </li>
                        <li @click="setPageLength(100)">
                            <a href="javascript:void(0)">100</a>
                        </li>
                    </ul>
                </li>
            </ul>
        </header>
        <div class="card-body">
            <div class="table-responsive">
                <div class="dataTables_wrapper no-footer">
                    <table class="table data-table dataTable no-footer">
                        <thead>
                            <tr>
                                <th v-if="selectableRows">
                                    <input type="checkbox" @click="selectAllRows" ref="selectAllRows">
                                </th>
                                <th
                                    v-for="(column, index) in columns"
                                    :key="index"
                                    :class="[columnSortingClasses[index], column.sortable !== false ? 'sorting' : '']"
                                    @click="setSorting(index)"
                                >
                                    {{column.displayName}}
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(row, index) in rows" :key="index">
                                <td v-if="selectableRows">
                                    <input type="checkbox" :value="row.id" v-model="selectedRows">
                                </td>
                                <td v-for="(column, index) in columns" :key="index">
                                    <Link v-if="column.linkParams" :href="generateLink(column.linkParams, row)">
                                        {{row[column.data]}}
                                    </Link>
                                    <span v-else>{{row[column.data]}}</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="dataTables_info">
                        Rāda {{firstRecord}}. līdz {{lastRecord}}. no {{recordsFiltered}} ierakstiem
                        <span v-if="recordsFiltered != recordsTotal">
                            (kopā {{ recordsTotal }} ierkasti)
                        </span>
                    </div>
                    <div class="dataTables_paginate paging_simple_numbers user-select-none" id="document-index-table_paginate">
                        <a
                            class="paginate_button first user-select-none"
                            :class="{disabled:columnSettings.start == 0}"
                            @click="setPage(1)"
                        >Pirmā</a>
                        <a
                            class="paginate_button previous"
                            :class="{disabled:columnSettings.start == 0}"
                            @click="setPage(currentPage - 1)"
                        >Iepriekšējā</a>

                        <span>
                            <a
                                v-for="(page, index) in pages"
                                class="paginate_button"
                                :class="{current: page == currentPage}"
                                @click="setPage(page)"
                            >{{ page }}</a>
                        </span>
                        <a
                            class="paginate_button next"
                            :class="{disabled:columnSettings.start >= lastPageStart}"
                            @click="setPage(currentPage + 1)"
                        >Nākamā</a>
                        <a
                            class="paginate_button last"
                            :class="{disabled:columnSettings.start >= lastPageStart}"
                            @click="setPage(pageCount)"
                        >Pēdējā</a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import axios from 'axios';
    import { Link } from '@inertiajs/vue3';
    export default {
        components: {
            Link,
        },
        props: {
            cardClasses: {
                type: String,
                required: false,
                default: null,
            },
            createLink: {
                type: String,
                required: false,
                default: null,
            },
            columns: {
                type: Array,
                required: true,
            },
            url: {
                type: String,
                required: true,
            },
            selectableRows: {
                type: Boolean,
                required: false,
                default: false,
            },
            order: {
                type: Array,
                required: false,
                default:  [
                    {
                        column: 0,
                        dir: 'asc',
                    }
                ],
            },
        },
        data() {
            return {
                searchBarOpen: false,
                rows: [],
                columnSettings: {},
                searchTerm: '',
                recordsTotal: 0,
                recordsFiltered: 0,
                selectedRows: [],
            }
        },
        watch: {
            selectedRows: function (val, oldVal) {
                if (!this.selectableRows) {
                    return;
                }

                if(val.length === this.rows.length && val.length > 0){
                    this.$refs.selectAllRows.indeterminate = false;
                    this.$refs.selectAllRows.checked = true;
                }else if(val.length === 0){
                    this.$refs.selectAllRows.indeterminate = false;
                    this.$refs.selectAllRows.checked = false;
                }else{
                    this.$refs.selectAllRows.indeterminate = true;
                }
            }
        },
        computed: {
            firstRecord(){
                return this.columnSettings.start + 1;
            },
            lastRecord(){
                return this.columnSettings.start + this.rows.length;
            },
            currentPage(){
                return Math.ceil(this.columnSettings.start / this.columnSettings.length) + 1;
            },
            pageCount(){
                return Math.ceil(this.recordsFiltered / this.columnSettings.length);
            },
            lastPageStart(){
                return (this.pageCount - 1) * this.columnSettings.length;
            },
            columnSortingClasses(){
                let classes = [];
                if(!this.columnSettings.order){
                    return classes;
                }

                for(let i = 0; i < this.columns.length; i++){
                    let sortDirection = '';
                    for(let j = 0; j < this.columnSettings.order.length; j++){
                        if(this.columnSettings.order[j].column == i){
                            sortDirection = this.columnSettings.order[j].dir == 'asc' ? 'sorting_asc' : 'sorting_desc';
                        }
                    }
                    classes.push(sortDirection);
                }
                return classes;
            },
            pages(){
                let pages = [];
                let start = this.currentPage - 2;
                let end = this.currentPage + 2;
                if(start < 1){
                    start = 1;
                    end = 5;
                }
                if(end > this.pageCount){
                    start = this.pageCount - 4;
                    end = this.pageCount;
                }
                if(start < 1){
                    start = 1;
                }
                for(let i = start; i <= end; i++){
                    pages.push(i);
                }
                return pages;
            },
        },
        methods:{
            alert(message){
                alert(message);
            },
            clearSearch(){
                this.searchBarOpen = false;
                this.$el.querySelector('.filter-input').value = '';
                this.columnSettings.search.value = '';

                this.loadData();
            },
            loadData(){
                this.columnSettings.draw++;
                this.clearSelectedRows();
                axios.get(this.url, {params: this.columnSettings}).then(response => {
                    this.rows = response.data.data;
                    this.recordsTotal = response.data.recordsTotal;
                    this.recordsFiltered = response.data.recordsFiltered;
                });
            },
            initColumnSettings(){
               this.columnSettings = {
                    draw: 0,
                    columns: this.columns.map((column, index) => {
                        return {
                            data: column.data,
                            name: column.name,
                            // if searchable is not set, default to true
                            searchable: column.searchable === undefined ? true : column.searchable,
                            sortable: column.sortable === undefined ? true : column.sortable,
                            search: {
                                value: '',
                                regex: false,
                            }
                        }
                    }),
                    order: this.order,
                    start: 0,
                    length: 10,
                    search: {
                        value: '',
                        regex: false,
                    },
                }
            },
            setPageLength(length){
                this.columnSettings.length = length;
                this.loadData();
            },
            setPage(page){
                if(page < 1 || page > this.pageCount){
                    return;
                }
                this.columnSettings.start = (page - 1) * this.columnSettings.length;
                this.loadData();
            },
            setSearchTerm(){
                // wait for user to stop typing
                setTimeout(() => {
                    this.columnSettings.search.value = this.$el.querySelector('.filter-input').value;
                    this.columnSettings.start = 0;
                    // set search term for each column if searchable
                    // this.columnSettings.columns.forEach((column, index) => {
                    //     if(column.searchable){
                    //         column.search.value = this.columnSettings.search.value;
                    //     }
                    // });
                    this.loadData();
                }, 500);
            },
            setSorting(index){
                // if column is not sortable, do nothing
                if(!this.columnSettings.columns[index].sortable){
                    return;
                }
                // console.log('sorting');
                // // if column is already sorted, reverse sort direction
                if(this.columnSettings.order[0].column == index){
                    this.columnSettings.order[0].dir = this.columnSettings.order[0].dir == 'asc' ? 'desc' : 'asc';
                }else{
                    // if column is not sorted, set it as first sort column
                    this.columnSettings.order = [
                        {
                            column: index,
                            dir: 'asc',
                        }
                    ];
                }
                this.loadData();
            },
            generateLink(linkParams, row){
                let resourceIds = [];
                linkParams.resourceIds.forEach((resourceId) => {
                    resourceIds.push(row[resourceId]);
                });
                return route(linkParams.name, resourceIds);
            },
            selectAllRows(){
                if(this.selectedRows.length == this.rows.length){
                    this.selectedRows = [];
                }else{
                    this.selectedRows = this.rows.map((row) => {
                        return row.id;
                    });
                }
            },
            clearSelectedRows(){
                this.selectedRows = [];
            },
        },
        mounted(){
            this.initColumnSettings();
            this.loadData();
        }

    }
</script>
