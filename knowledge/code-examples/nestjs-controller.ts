import { Controller, Get, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('example')
@Controller('example')
export class ExampleController {

  @Get()
  findAll() {
    return 'This action returns all examples';
  }

  @Post()
  create() {
    return 'This action adds a new example';
  }
}

