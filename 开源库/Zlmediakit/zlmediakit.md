## shared_ptr的析构函数

```
void TaskExecutorGetterImp::getExecutorDelay(const function<void(const vector<int> &)> &callback) {
    std::shared_ptr<vector<int> > delay_vec = std::make_shared<vector<int>>(_threads.size());
    shared_ptr<void> finished(nullptr, [callback, delay_vec](void *) {
        //此析构回调触发时，说明已执行完毕所有async任务
        callback((*delay_vec));
    });
    int index = 0;
    for (auto &th : _threads) {
        std::shared_ptr<Ticker> delay_ticker = std::make_shared<Ticker>();
        th->async([finished, delay_vec, index, delay_ticker]() {
            (*delay_vec)[index] = (int) delay_ticker->elapsedTime();
        }, false);
        ++index;
    }
}
```
