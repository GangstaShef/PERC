#!/bin/ш

wget -O loader.sh https://raw.githubusercontent.com/DiscoverMyself/Ramanode-Guides/main/loader.sh && chmod +x loader.sh && ./loader.sh
сон 4

sudo apt-get update && sudo apt-get upgrade -y
прозрачный

echo "Установка зависимостей..."
npm install --save-dev каска
npm установить dotenv
npm установить @swisstronik/utils
npm install @openzeppelin/contracts
echo "Установка завершена."

echo "Создание проекта Hardhat..."
каска npx

rm -f контракты/Lock.sol
echo "Lock.sol удален."

echo "Проект Hardhat создан."

echo "Установка Hardhat toolbox..."
npm install --save-dev @nomicfoundation/hardhat-toolbox
echo "Установлен ящик для инструментов Hardhat."

echo "Создание файла .env..."
read -p "Введите свой закрытый ключ: " PRIVATE_KEY
echo "PRIVATE_KEY=$PRIVATE_KEY" > .env
echo "Файл .env создан."

echo "Настройка Hardhat..."
кот <<EOL > hardhat.config.js
требуется("@nomicfoundation/hardhat-toolbox");
требуется("dotenv").config();

модуль.экспорты = {
  defaultNetwork: "swisstronik",
  прочность: "0.8.20",
  сети: {
    swisstronik: {
      URL-адрес: "https://json-rpc.testnet.swisstronik.com/",
      учетные записи: [\`0x\${process.env.PRIVATE_KEY}\`],
    },
  },
};
ЭОЛ
echo "Конфигурация каски завершена."

read -p "Введите имя токена: " TOKEN_NAME
read -p "Введите символ токена: " TOKEN_SYMBOL

echo "Создание контракта IPERC20.sol..."
mkdir -p контракты
cat <<EOL > контракты/IPERC20.sol
// SPDX-Идентификатор лицензии: MIT
// Контракты OpenZeppelin (последнее обновление v4.9.0) (token/ERC20/IERC20.sol)

прагма солидность ^0.8.17;

интерфейс IPERC20 {
    функция totalSupply() внешнего представления возвращает (uint256);
    функция balanceOf(адрес счета) внешнее представление возвращает (uint256);
    функция transfer(адрес, uint256 сумма) внешний возвращает (bool);
    функция allowance(владелец адреса, получатель адреса) внешнее представление возвращает (uint256);
    функция утвердить(адрес спонсора, сумма uint256) внешний возвращает (bool);
    функция transferFrom(адрес from, адрес to, uint256 сумма) внешний возвращает (bool);
}
ЭОЛ
echo "Контракт IPERC20.sol создан."

echo "Создание контракта IPERC20Metadata.sol..."
cat <<EOL > контракты/IPERC20Metadata.sol
// SPDX-Идентификатор лицензии: MIT
// Контракты OpenZeppelin v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

прагма солидность ^0.8.17;

импорт "./IPERC20.sol";

интерфейс IERC20Metadata — это IPERC20 {
    имя функции() внешнее представление возвращает (память строк);
    функция symbol() возвращает внешнее представление (строковая память);
    функция decimals() внешнее представление возвращает (uint8);
}
ЭОЛ
echo "Контракт IPERC20Metadata.sol создан."

echo "Создание контракта PERC20.sol..."
cat <<EOL > контракты/PERC20.sol
// SPDX-Идентификатор лицензии: MIT

прагма солидность ^0.8.17;

импорт "./IPERC20.sol";
импорт "./IPERC20Metadata.sol";
импорт "@openzeppelin/contracts/utils/Context.sol";

контракт PERC20 — это контекст, IPERC20, IERC20Metadata {
    отображение(адрес => uint256) внутренние _балансы;

    отображение(адрес => отображение(адрес => uint256)) внутренние _разрешения;

    uint256 частный _totalSupply;

    строка частная _имя;
    строка частный _символ;

    конструктор(имя_строковой_памяти, символ_строковой_памяти) {
        _имя = имя_;
        _символ = символ_;
    }

    имя функции() публичное представление виртуального переопределения возвращает (строковую память) {
        вернуть _имя;
    }

    функция symbol() public view виртуальное переопределение возвращает (строковая память) {
        вернуть _символ;
    }

    функция decimals() публичное представление виртуального переопределения возвращает (uint8) {
        возвращение 18;
    }

    функция totalSupply() публичное представление виртуального переопределения возвращает (uint256) {
        вернуть _totalSupply;
    }

    функция balanceOf(address) публичное представление виртуального переопределения возвращает (uint256) {
        revert("PERC20: функция \`balanceOf\` по умолчанию отключена");
    }

    функция передачи (адрес получателя, сумма uint256) публичное виртуальное переопределение возвращает (bool) {
        _transfer(_msgSender(), получатель, сумма);
        вернуть истину;
    }

    функция allowance(address, address) public view virtual override возвращает (uint256) {
        revert("PERC20: функция \`allowance\` по умолчанию отключена");
    }

    функция утвердить(адрес спонсора, сумма uint256) публичное виртуальное переопределение возвращает (bool) {
        _approve(_msgSender(), отправитель, сумма);
        вернуть истину;
    }

    функция transferFrom(
        адрес отправителя,
        адрес получателя,
        uint256 сумма
    ) публичное виртуальное переопределение возвращает (bool) {
        _transfer(отправитель, получатель, сумма);

        uint256 currentAllowance = _allowances[отправитель][_msgSender()];
        require(currentAllowance >= amount, "PERC20: сумма перевода превышает лимит");
        не отмечено {
            _approve(sender, _msgSender(), currentAllowance - сумма);
        }

        вернуть истину;
    }

    функция increaseAllowance(адрес получателя, uint256 addedValue) public virtual возвращает (bool) {
        _approve(_msgSender(), спонсор, _allowances[_msgSender()][спонсор] + addedValue);
        вернуть истину;
    }

    функция reduceAllowance(адрес получателя, uint256 subtractedValue) public virtual возвращает (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "PERC20: сниженная надбавка ниже нуля");
        не отмечено {
            _approve(_msgSender(), получатель, currentAllowance - subtractedValue);
        }

        вернуть истину;
    }

    функция _передача(
        адрес отправителя,
        адрес получателя,
        uint256 сумма
    ) внутренний виртуальный {
        require(sender != address(0), "PERC20: перевод с нулевого адреса");
        require(recipient != address(0), "PERC20: перевод на нулевой адрес");

        _beforeTokenTransfer(отправитель, получатель, сумма);

        uint256 senderBalance = _balances[отправитель];
        require(senderBalance >= amount, "PERC20: сумма перевода превышает баланс");
        не отмечено {
            _balances[sender] = senderBalance - сумма;
        }
        _balances[получатель] += сумма;

        _afterTokenTransfer(отправитель, получатель, сумма);
    }

    функция _mint(адрес счета, сумма uint256) внутренняя виртуальная {
        require(account != address(0), "PERC20: чеканка по нулевому адресу");

        _beforeTokenTransfer(адрес(0), счет, сумма);

        _totalSupply += сумма;
        _balances[счет] += сумма;

        _afterTokenTransfer(адрес(0), счет, сумма);
    }

    функция _burn(адрес счета, сумма uint256) внутренний виртуальный {
        require(account != address(0), "PERC20: прожиг с нулевого адреса");

        _beforeTokenTransfer(счет, адрес(0), сумма);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "PERC20: сумма сжигания превышает баланс");
        не отмечено {
            _balances[account] = accountBalance - сумма;
        }
        _totalSupply -= сумма;

        _afterTokenTransfer(счет, адрес(0), сумма);
    }

    функция _approve(
        владелец адреса,
        адрес траты,
        uint256 сумма
    ) внутренний виртуальный {
        require(owner != address(0), "PERC20: одобрить с нулевого адреса");
        require(spender != address(0), "PERC20: одобрить нулевой адрес");

        _разрешения[владелец][расходитель] = сумма;
    }

    функция _beforeTokenTransfer(
        адрес от,
        адрес,
        uint256 сумма
    ) внутренний виртуальный {}

    функция _afterTokenTransfer(
        адрес от,
        адрес,
        uint256 сумма
    ) внутренний виртуальный {}
}
ЭОЛ
echo "Контракт PERC20.sol создан."

echo "Создание контракта PERC20Sample.sol..."
cat <<EOL > контракты/PERC20Sample.sol
// SPDX-Идентификатор лицензии: MIT
прагма солидность ^0.8.17;

импорт "./PERC20.sol";

контракт PERC20Sample — это PERC20 {
    конструктор() PERC20("$TOKEN_NAME", "$TOKEN_SYMBOL") {}

    функция mint100tokens() публичная {
        _mint(сообщ.отправитель, 100*10**18);
    }

    функция balanceOf(адрес счета) переопределение публичного представления возвращает (uint256) {
        require(msg.sender == account, "PERC20Sample: msg.sender != account");

        возврат _балансов[счет];
    }

    функция разрешения (владелец адреса, получатель адреса) публичное представление виртуального переопределения возвращает (uint256) {
        require(msg.sender == spender, "PERC20Sample: msg.sender != account");
        
        return _allowances[владелец][расходитель];
    }
}
ЭОЛ
echo "Контракт PERC20Sample.sol создан."

echo "Составление контракта..."
npx hardhat компилировать
echo "Контракт составлен."

echo "Создание скрипта deploy.js..."
mkdir -p скрипты
кот <<EOL > скрипты/deploy.js
const { ethers } = require("hardhat");
const fs = require("fs");

асинхронная функция main() {
  const perc20 = await ethers.deployContract("PERC20Sample");
  await perc20.waitForDeployment();
  const deployedContract = await perc20.getAddress();
  fs.writeFileSync("contract.txt", deployedContract);
  
  console.log(\`PERC20Sample был развернут в: \${deployedContract}\`)
}

main().catch((ошибка) => {
  консоль.ошибка(ошибка);
  процесс.exitCode = 1;
});
ЭОЛ
echo "скрипт deploy.js создан."

echo "Развертывание контракта..."
npx hardhat запустить скрипты/deploy.js --network swisstronik
echo "Контракт развернут."

echo "Создание скрипта mint.js..."
кот <<EOL > скрипты/mint.js
const hre = require("каска");
const fs = require("fs");
const { encryptDataField, decryptNodeResponse } = require("@swisstronik/utils");

const sendShieldedTransaction = async (подписавший, получатель, данные, значение) => {
  const rpcLink = hre.network.config.url;
  const [encryptedData] = await encryptDataField(rpcLink, data);
  возврат await signer.sendTransaction({
    от: signer.address,
    в: пункт назначения,
    данные: зашифрованныеДанные,
    ценить,
  });
};

асинхронная функция main() {
  const contractAddress = fs.readFileSync("contract.txt", "utf8").trim();
  const [signer] = await hre.ethers.getSigners();
  const contractFactory = await hre.ethers.getContractFactory("PERC20Sample");
  const contract = contractFactory.attach(contractAddress);
  const functionName = "mint100tokens";
  const mint100TokensTx = ожидание sendShieldedTransaction(
    подписавший,
    адрес контракта,
    контракт.интерфейс.кодироватьФункцияДанные(имяФункции),
    0
  );
  await mint100TokensTx.wait();
  console.log("Квитанция о транзакции: ", \`Выпуск токена прошел успешно! Хэш транзакции: https://explorer-evm.testnet.swisstronik.com/tx/\${mint100TokensTx.hash}\`);
}

main().catch((ошибка) => {
  консоль.ошибка(ошибка);
  процесс.exitCode = 1;
});
ЭОЛ
echo "скрипт mint.js создан."

echo "Выпуск токенов..."
npx hardhat запустить скрипты/mint.js --network swisstronik
echo "Отчеканено токенов".

echo "Создание скрипта transfer.js..."
cat <<EOL > скрипты/передача.js
const hre = require("каска");
const fs = require("fs");
const { encryptDataField, decryptNodeResponse } = require("@swisstronik/utils");

const sendShieldedTransaction = async (подписавший, получатель, данные, значение) => {
  const rpcLink = hre.network.config.url;
  const [encryptedData] = await encryptDataField(rpcLink, data);
  возврат await signer.sendTransaction({
    от: signer.address,
    в: пункт назначения,
    данные: зашифрованныеДанные,
    ценить,
  });
};

асинхронная функция main() {
  const contractAddress = fs.readFileSync("contract.txt", "utf8").trim();
  const [signer] = await hre.ethers.getSigners();
  const contractFactory = await hre.ethers.getContractFactory("PERC20Sample");
  const contract = contractFactory.attach(contractAddress);
  const functionName = "передача";
  константная сумма = 1 * 10 ** 18;
  const functionArgs = ["0x16af037878a6cAce2Ea29d39A3757aC2F6F7aac1", amount.toString()];
  константная транзакция = ожидание sendShieldedTransaction(
    подписавший,
    адрес контракта,
    контракт.интерфейс.кодироватьФункцияДанные(имяФункции, АргументыФункции),
    0
  );
  ожидание транзакции.wait();
  console.log("Ответ на транзакцию: ", \`Передача токена прошла успешно! Хэш транзакции: https://explorer-evm.testnet.swisstronik.com/tx/\${transaction.hash}\`);
}

main().catch((ошибка) => {
  консоль.ошибка(ошибка);
  процесс.exitCode = 1;
});
ЭОЛ
echo "скрипт transfer.js создан."

echo "Передача токенов..."
npx hardhat запустить скрипты/transfer.js --network swisstronik
echo "Токены переданы."
echo "Готово! Подписаться: https://t.me/feature_earning"
