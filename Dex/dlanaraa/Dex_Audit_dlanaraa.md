# dlanaraa


## name-reused
### 설명
코드베이스에 이름이 비슷한 두 개의 컨트랙트가 있는 경우 컴파일 아티팩트에는 이름이 중복된 컨트랙트 중 하나가 포함되지 않는다.

- [Dex] src/Dex.sol
- [Dex] ser/dex.sol

### 파급력
Impact : High

### 해결방안
컨트랙트의 이름을 변경한다.



## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.


swap 함수
- 50 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 51 Line : tokenX.transfer(msg.sender,outputAmount)
- 66 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 67 Line : tokenY.transfer(msg.sender,outputAmount)

addLiquidity 함수
- 105 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 106 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)

removeLiquidity 함수
- 134 Line : tokenX.transfer(msg.sender,_receiveX)
- 135 Line : tokenY.transfer(msg.sender,_receiveY)


### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.




## divide-before-multiply
### 설명
나눗셈을 한 결과값에 곱셈을 수행함.


swap 함수
- 40 Line : outputAmount = (tokenXpool * (tokenYAmount * 999 / 1000)) / (tokenYpool + (tokenYAmount * 999 / 1000))
- 59 Line : outputAmount = (tokenYpool * (tokenXAmount * 999 / 1000)) / (tokenXpool + (tokenXAmount * 999 / 1000))

### 파급력
Impact : Medium

### 해결방안
나눗셈을 하기전에 곱셈을 하는 로직을 고려한다.





## locked-ether
### 설명
ETH의 payable 함수를 통해 지급 기능이 있지만, 출금 기능이 없어서 ETH가 컨트랙트에 귀속된다.


- 146 Line : receive()

### 파급력
Impact : Medium

### 해결방안
payable 속성을 제거하거나 withdraw 함수를 추가한다.



## events-maths
### 설명
중요한 산술 매개변수에 대한 누락된 이벤트를 감지.


addLiquidity 함수
- 101 Line : tokenXpool += tokenXAmount
- 102 Line : tokenYpool += tokenYAmount

removeLiquidity 함수
- 129 Line : tokenXpool -= _receiveX
- 130 Line : tokenYpool -= _receiveY


### 파급력
Impact : Low

### 해결방안
중요한 매개변수 변경에 대한 이벤트를 발생시킨다.




## unused-state
### 설명
사용하지 않는 상태변수가 선언되어 있다.


Dex.sol 파일
- 11 Line : Dex._amountLPT


### 파급력
Impact : Informational


### 해결방안
사용하지 않는 상태변수를 삭제한다.
