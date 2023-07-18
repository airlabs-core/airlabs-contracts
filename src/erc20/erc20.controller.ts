import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { Erc20Service } from './erc20.service';
import { CreateErc20Dto } from './dto/create-erc20.dto';
import { UpdateErc20Dto } from './dto/update-erc20.dto';

@Controller('erc20')
export class Erc20Controller {
  constructor(private readonly erc20Service: Erc20Service) {}

  @Post()
  create(@Body() createErc20Dto: CreateErc20Dto) {
    return this.erc20Service.create(createErc20Dto);
  }

  @Get()
  findAll() {
    return this.erc20Service.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.erc20Service.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateErc20Dto: UpdateErc20Dto) {
    return this.erc20Service.update(+id, updateErc20Dto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.erc20Service.remove(+id);
  }
}
