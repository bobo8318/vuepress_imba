module.exports = {
    //theme: 'vuepress-theme-yilia-plus',
    title: 'IMBAPUB', 
    description: `imba blog`,
    head: [
        ['link', { rel: 'icon', href: `/favicon.ico` }]
    ],
    base: '/',
    repo: 'https://github.com/lewiscutey/vuepress-template',
    dest: './docs/.vuepress/dist',
    ga: '',
    serviceWorker: true,
    evergreen: true,
    themeConfig: {
        background: `/img/`,
        github: 'lewiscutey',
        logo: '/img/logo.png',
        accentColor: '#ac3e40',
        per_page: 6,
        date_format: 'yyyy-MM-dd HH:mm:ss',
        tags: true,
        comment: {
            clientID: '',
            clientSecret: '',
            repo: '',  // blog of repo name
            owner: '',  // github of name
            admin: '', // github of name
            distractionFreeMode: false
        },
        nav: require("./nave"),
        sidebar: require("./sidebar")
    },
    markdown: {
        anchor: {
            permalink: true
        },
        toc: {
            includeLevel: [1, 2]
        },
        config: md => {
            // 使用更多 markdown-it 插件！
            md.use(require('markdown-it-task-lists'))
            .use(require('markdown-it-imsize'), { autofill: true })
        }
    },
    postcss: {
        plugins: [require('autoprefixer')]
    },
}

