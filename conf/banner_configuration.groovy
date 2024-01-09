bannerDataSource.url="jdbc:oracle:thin:@//${oracle.host}/${oracle.service_name}"
bannerDataSource.username="${banner9.proxy.user}"
bannerDataSource.password="${banner9.proxy.password}"

bannerSsbDataSource.url="jdbc:oracle:thin:@//${oracle.host}/${oracle.service_name}"
bannerSsbDataSource.username="${banner9.proxy.user}"
bannerSsbDataSource.password="${banner9.proxy.password}"

banner.transactionTimeout = 600
configJob {
    // Recommended default is every 1 hour starting at 00am, of every day - "0 0 */1 * * ?"
    // Cron expression lesser than 30 mins will fall back to 30 mins.
    cronExpression = "*/30 * * * *"
}
