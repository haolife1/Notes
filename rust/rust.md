# rust 'a 用法
    在Rust编程语言中，'a 是生命周期参数的标识符，通常用于指定引用的生命周期。在函数签名或数据结构中，'a 表示一个未知的生命周期，它可以是任何引用的生命周期。这对于在函数中接受引用或在数据结构中存储引用时很有用，因为它允许编译器检查引用的有效性。

    例如，如果你有一个函数，接受一个字符串切片并返回第一个字符的引用，你可能会写成这样：
```
fn first_char<'a>(s: &'a str) -> Option<&'a char> {
    s.chars().next()
}
```
    在这里，<'a> 是一个生命周期参数，表示引用的生命周期与函数的生命周期相关联。在这个例子中，它意味着返回的字符引用将与输入字符串切片具有相同的生命周期。
在使用结构体时，也可以使用 'a 表示引用的生命周期，例如：
```
struct MyStruct<'a> {
    data: &'a str,
}
```
这意味着 MyStruct 的实例必须包含一个生命周期至少与其包含的引用的生命周期相同的 'a 生命周期。

总之，'a 在Rust中是用于表示生命周期参数的标识符，它帮助编译器进行引用的有效性检查和内存管理。

#  unwrap
在 Rust 中，unwrap() 是一个由 Option<T> 和 Result<T, E> 类型提供的方法，用于获取其中的值，如果是 None 或 Err，则会引发 panic。

对于 Option<T>:

当你有一个 Option<T> 类型的值时，你可以使用 unwrap() 方法来提取其中的值。如果 Option<T> 是 Some(value)，那么 unwrap() 将返回 value；如果 Option<T> 是 None，则 unwrap() 会引发 panic。
例如：

```
let some_value: Option<i32> = Some(5);
let unwrapped_value = some_value.unwrap();
println!("Unwrapped value: {}", unwrapped_value); // 输出: Unwrapped value: 5
```
对于 Result<T, E>:

当你有一个 Result<T, E> 类型的值时，你可以使用 unwrap() 方法来获取其中的值。如果 Result<T, E> 是 Ok(value)，那么 unwrap() 将返回 value；如果 Result<T, E> 是 Err(err)，则 unwrap() 会引发 panic，并输出 err。
例如：

```
let result: Result<i32, &str> = Ok(10);
let unwrapped_value = result.unwrap();
println!("Unwrapped value: {}", unwrapped_value); // 输出: Unwrapped value: 10
```
或者：

```
let result: Result<i32, &str> = Err("An error occurred");
let unwrapped_value = result.unwrap(); // 这里会引发 panic，输出错误消息
```
虽然 unwrap() 是一种方便的方法，但在实际代码中，最好使用更安全的方法来处理可能存在的错误，例如使用 match 或者 unwrap_or()、expect() 等方法，这样可以更好地处理错误而不会引发 panic。

## 在Rust中，pub fn abort() -> !; 的含义如下：
pub: 这个函数是公开的，可以在其它模块中被访问和调用。
fn: 这是一个函数声明。
abort(): 这是函数的名称，名为abort。
-> !: 这个函数返回一个特殊的类型!，它表示"never"类型，也称为发散类型。这意味着abort函数不会正常返回，而是会终止程序的执行。当调用这个函数时，程序会立即停止执行并且不会返回到调用点。
在Rust中，! 类型通常用于表示永远不会返回的函数，比如panic、abort等。这有助于编译器进行更严格的分析，确保代码的安全性和正确性。

## 引用与借用
引用（reference）像一个指针，因为它是一个地址，我们可以由此访问储存于该地址的属于其他变量的数据。 与指针不同，引用确保指向某个特定类型的有效值。
将创建一个引用的行为称为 借用（borrowing）
与使用 & 引用相反的操作是 解引用（dereferencing），它使用解引用运算符，*。
我们通过一个小调整就能修复示例 4-6 代码中的错误，允许我们修改一个借用的值，这就是 可变引用（mutable reference）：
```
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```
### 无法同时借用可变和不可变
  可变引用有一个很大的限制：如果你有一个对该变量的可变引用，你就不能再创建对该变量的引用。这些尝试创建两个 s 的可变引用的代码会失败
### NLL
  对于这种编译器优化行为，Rust 专门起了一个名字 —— Non-Lexical Lifetimes(NLL)，专门用于找到某个引用在作用域(})结束前就不再被使用的代码位置。

### 悬垂引用(Dangling References)
悬垂引用也叫做悬垂指针，意思为指针指向某个值后，这个值被释放掉了，而指针仍然存在，其指向的内存可能不存在任何值或已被其它变量重新使用。在 Rust 中编译器可以确保引用永远也不会变成悬垂状态：当你获取数据的引用后，编译器可以确保数据不会在引用结束前被释放，要想释放数据，必须先停止其引用的使用。

## 闭包
|param1, param2,...| {
    语句1;
    语句2;
    返回表达式
}

* exec(mut f: F)表明我们的exec接收的是一个可变类型的闭包。
* 闭包自动实现Copy特征的规则是，只要闭包捕获的类型都实现了Copy特征的话，这个闭包就会默认实现Copy特征。
* 而如果拿到的是s的所有权或可变引用，都是不能Copy的。

### 闭包特征
* 所有的闭包都自动实现了 FnOnce 特征，因此任何一个闭包都至少可以被调用一次
* 没有移出所捕获变量的所有权的闭包自动实现了 FnMut 特征
* 不需要对捕获变量进行改变的闭包自动实现了 Fn 特征
* 虽然类型推导很好用，但是它不是泛型，当编译器推导出一种类型后，它就会一直使用该类型：
* 一个闭包实现了哪种 Fn 特征取决于该闭包如何使用被捕获的变量，而不是取决于闭包如何捕获它们，跟是否使用 move 没有必然联系。

## 迭代器
* into_iter 会夺走所有权
* iter 是借用
* iter_mut 是可变借用

## 点操作符
let array: Rc<Box<[T; 3]>> = ...;
let first_entry = array[0];
array 数组的底层数据隐藏在了重重封锁之后，那么编译器如何使用 array[0] 这种数组原生访问语法通过重重封锁，准确的访问到数组中的第一个元素？

首先， array[0] 只是Index特征的语法糖：编译器会将 array[0] 转换为 array.index(0) 调用，当然在调用之前，编译器会先检查 array 是否实现了 Index 特征。
接着，编译器检查 Rc<Box<[T; 3]>> 是否有实现 Index 特征，结果是否，不仅如此，&Rc<Box<[T; 3]>> 与 &mut Rc<Box<[T; 3]>> 也没有实现。
上面的都不能工作，编译器开始对 Rc<Box<[T; 3]>> 进行解引用，把它转变成 Box<[T; 3]>
此时继续对 Box<[T; 3]> 进行上面的操作 ：Box<[T; 3]>， &Box<[T; 3]>，和 &mut Box<[T; 3]> 都没有实现 Index 特征，所以编译器开始对 Box<[T; 3]> 进行解引用，然后我们得到了 [T; 3]
[T; 3] 以及它的各种引用都没有实现 Index 索引(是不是很反直觉:D，在直觉中，数组都可以通过索引访问，实际上只有数组切片才可以!)，它也不能再进行解引用，因此编译器只能祭出最后的大杀器：将定长转为不定长，因此 [T; 3] 被转换成 [T]，也就是数组切片，它实现了 Index 特征，因此最终我们可以通过 index 方法访问到对应的元素。

## newtype
何为 newtype？简单来说，就是使用元组结构体的方式将已有的类型包裹起来：struct Meters(u32);，那么此处 Meters 就是一个 newtype。

## DST(dynamically sized types)
Rust 中常见的 DST 类型有: str、[T]、dyn Trait，它们都无法单独被使用，必须要通过引用或者 Box 来间接使用 。

## 互斥的 Copy 和 Drop
我们无法为一个类型同时实现 Copy 和 Drop 特征。因为实现了 Copy 的特征会被编译器隐式的复制，因此非常难以预测析构函数执行的时间和频率。因此这些实现了 Copy 的类型无法拥有析构函数。

## Rc 简单总结
Rc/Arc 是不可变引用，你无法修改它指向的值，只能进行读取，如果要修改，需要配合后面章节的内部可变性 RefCell 或互斥锁 Mutex
一旦最后一个拥有者消失，则资源会自动被回收，这个生命周期是在编译期就确定下来的
Rc 只能用于同一线程内部，想要用于线程之间的对象共享，你需要使用 Arc
Rc<T> 是一个智能指针，实现了 Deref 特征，因此你无需先解开 Rc 指针，再使用里面的 T，而是可以直接使用 T，例如上例中的 gadget1.owner.name

## Arc
Arc 是 Atomic Rc 的缩写，顾名思义：原子化的 Rc<T> 智能指针。原子化是一种并发原语，我们在后续章节会进行深入讲解，这里你只要知道它能保证我们的数据能够安全的在线程间共享即可。

## Send
通道关闭的两个条件：发送者全部drop或接收者被drop，要结束for循环显然是要求发送者全部drop，但是由于send自身没有被drop，会导致该循环永远无法结束，最终主线程会一直阻塞。

## 互斥锁
* 在使用数据前必须先获取锁
* 在数据使用完成后，必须及时的释放锁，比如文章开头的例子，使用内部语句块的目的就是为了及时的释放锁

## RW锁
使用RwLock要确保满足以下两个条件：并发读，且需要对读到的资源进行"长时间"的操作，HashMap也许满足了并发读的需求，但是往往并不能满足后者："长时间"的操作。

## 内存顺序
内存顺序是指 CPU 在访问内存时的顺序，该顺序可能受以下因素的影响：

代码中的先后顺序
编译器优化导致在编译阶段发生改变(内存重排序 reordering)
运行阶段因 CPU 的缓存机制导致顺序被打乱